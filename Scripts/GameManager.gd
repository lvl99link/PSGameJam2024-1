class_name GameManager
extends Node2D

enum ROUND {START, SLIMING, ENDING}
const MAX_SPEED = 1000 # Fine tune
const MAX_SLIMES = 4

@export var camera: Camera2D
@export var player_start_areas: Array[Area2D] ## List of area's from the editor where player's launch from

@onready var state: ROUND = ROUND.START
@onready var timer: Timer = $Timer

var player_count: int = 2 		# Max static 2 for now
var players: Array[Player]
var turn: int = 1 				# Which player is currently going (Maybe change type to Player)
var rounds_elapsed: int = 0

var launch_strength: float = 0.0 # Pct% value between 0 and 1
var active_slime: Slime # Which slime is currently selected to be fired
var camera_target: Node2D # Which node the main camera should focus/pan to

# Import slime prefabs
var neutral_slime_prefab = preload("res://Prefabs/slime.tscn")

func _ready() -> void:
	# Fill out the players array
	initialize_players()
	
	# Fill out each player's roster (hardcoded rn)
	initialize_rosters()
	
	camera_target = player_start_areas[turn - 1]
	
func _process(_delta: float) -> void:
	# Debugging:
	if Input.is_action_pressed("reset"): get_tree().reload_current_scene()
	# Check state of game
	if state == ROUND.START:
		handle_start_state()
	# TODO: Don't limit movements to the mouse position (controller support would be nice)
	# If we're in the start (prelaunch) state, we want certain things to be true:
	# 1. Should be able to select your slime
	# 2. Selected slime's position moves into the starting area
	# 3. Movement of 'cursor' should lock slime movement onto the starting line to determine position
	# 4. Cannot move the slime beyond the bounds of the area
	# 5. Clicking some button locks the position in place.
	# 6. If locked, moving the cursor now changes the angle/direction of launch
	# 7. If locked, clicking launches
	# 8. Hold click? to increase strength of launch
	# 9. Camera position is locked to the player's starting area.
		pass
	elif state == ROUND.SLIMING:
		handle_sliming_state()
	# If we're in the sliming state, all we need to do is disable all user inputs and 
	# manage physics, collisions, camera to follow slime, etc for as long as all the active slimes' velocity is > 0
	# Once the slimes stop, wait x seconds before switching to the next player's turn and repeating the process
		pass

func _physics_process(_delta: float) -> void:
	if camera_target:
		camera.global_position.x = camera_target.global_position.x

func initialize_players() -> void:
	for i in player_count:
		var new_player = Player.new()
		new_player.player_num = i+1
		players.append(new_player)

func initialize_rosters() -> void:
	for player in players:
		# Hard coding filling out each player's roster for now
		for i in MAX_SLIMES:
			var slime = neutral_slime_prefab.instantiate()
			player.roster.append(slime)

func handle_start_state() -> void:
	# WARNING: Runs once every loop; take care of performance.
	var area: Area2D = player_start_areas[clamp(turn - 1, 0, len(player_start_areas) - 1)] as Area2D
	var collider: CollisionShape2D = area.get_child(0) as CollisionShape2D
	var shape: Rect2 = collider.shape.get_rect()
	
	if not active_slime:
		select_slime(0)
		area.add_child(active_slime)
	active_slime.global_position.y = clamp(get_global_mouse_position().y, shape.size.y * -1 / 2, shape.size.y / 2)
	active_slime.position.x = collider.shape.get_rect().position.x + (collider.shape.get_rect().size.x)
	
	if Input.is_action_just_released("fire"):
		state = ROUND.SLIMING
		active_slime.can_move = true
		active_slime.trail.can_draw = true
		launch_slime()

func handle_sliming_state() -> void:
	# start a timer. if the velocity is low enough for long enough, start the next turn
	if active_slime.linear_velocity.x < 5 and timer.is_stopped():
		timer.start(3)
	await timer.timeout
	if active_slime and abs(active_slime.linear_velocity.x) < 5:
		next_turn()
	else:
		return

func select_slime(idx: int) -> void:
	active_slime = players[turn - 1].roster[idx]

func launch_slime() -> void:
	launch_strength = 1 # debug until actual force calculations are made
	# Always launch in the direction of the arena
	var direction = active_slime.global_position.direction_to(get_viewport_rect().end / 2).x
	direction = floor(direction) if direction < 0 else ceil(direction)
	
	var strength = launch_strength * MAX_SPEED
	var angle = get_global_mouse_position().direction_to(active_slime.position)
	var x = strength * angle.x * direction # ALWAYS SHOULD BE TOWARDS CENTER OF MAP
	var y = strength * angle.y
	active_slime.apply_impulse(Vector2(x, y))
	swap_camera_to(active_slime)
	Globals.play_random_sfx(active_slime.audio_player, active_slime.slime_throws)
	
	# TODO: curving slimes with bezier curves and square functions

func swap_camera_to(target: Node2D = null):
	if target == null:
		camera_target = player_start_areas[turn - 1]
		return
	camera_target = target

func next_turn() -> void:
	print("Starting the next Turn")
	players[turn - 1].remove_slime_from_roster(active_slime)
	active_slime = null
	
	turn += 1
	if turn > player_count:
		turn = 1
		rounds_elapsed += 1
		print(rounds_elapsed)
	if rounds_elapsed == MAX_SLIMES:
		state = ROUND.ENDING
		return
	#active_slime.trail.can_draw = false
	swap_camera_to(player_start_areas[0])
	state = ROUND.START
