class_name GameManager
extends Node2D

enum ROUND {START, SLIMING, ENDING}
const MAX_SPEED = 1500 # Fine tune
var MAX_SLIMES = Globals.slime_count

@export var camera: CustomCamera ## Current scene's camera
@export var player_start_areas: Array[Area2D] ## List of areas from the editor where players launch from
@export var score_ui: ScoreUI ## UI Control node that has the score GUI
@export var victory_ui: VictoryUI ## UI Control node that has the victory screen GUI
@export var strength_bar_ui: TextureProgressBar ## Progress bar for strength line

@onready var state: ROUND = ROUND.START
@onready var timer: Timer = $Timer
@onready var cursor_area: Area2D = $CursorArea # Used for detecting slimes under our cursor
@onready var drag_line: StrengthLine = StrengthLine.new() # The 'strength indicator and angle' line

const FLICK_A_WET = preload("res://Assets/SFX/OGG/Impacts/flick_A_WET.ogg")

var player_count: int = 2 		# Max static 2 for now
var players: Array[Player]
var turn: int = 1 				# Which player is currently going (Maybe change type to Player)
var rounds_elapsed: int = 0
var target_areas = []

var launch_strength: float = 0.0 # Pct% value between 0 and 1
var active_slime: Slime # Which slime is currently selected to be fired
var held_slime: Slime # Which slime is currently being held and dragged around
var camera_target: Node2D # Which node the main camera should focus/pan to
var last_valid_slime_pos: Vector2 # Variable to hold the last slime position in case of invalid drag and drop
var can_drag: bool # State to hold whether or not a prepped slime can be dragged back and launched

# Import slime prefabs
var slime_prefab = preload("res://Prefabs/slime.tscn")

func _ready() -> void:
	Globals.camera = camera
	# Fill out the players array
	initialize_players()
	# Fill out each player's roster (hardcoded rn)
	initialize_rosters()
	
	# Move camera to the current player's starting area
	camera_target = player_start_areas[turn - 1]
	
	add_child(drag_line)

func _process(_delta: float) -> void:
	# Debugging:
	if Input.is_action_pressed("reset"): get_tree().reload_current_scene()
	cursor_area.global_position = get_global_mouse_position()
	# Check state of game
	if state == ROUND.START:
		handle_start_state()
	elif state == ROUND.SLIMING:
		handle_sliming_state()

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
		var area: Area2D = player_start_areas[player.player_num - 1]
		var spawn_points = area.get_node("SpawnPoints").get_children()
		# Hard coding filling out each player's roster for now
		for i in MAX_SLIMES:
			var slime: Slime = slime_prefab.instantiate() as Slime
			slime.owned_by = player
			player.roster.append(slime)
			player.available_roster.append(slime)
			slime.slime_impacted.connect(on_slime_impact) # NOTE to delete this if scrapping final slaunch
			slime.position = spawn_points[i].position
			
			area.add_child(slime)

func handle_start_state() -> void:
	# WARNING: Runs once every loop; take care of performance.
	# TODO:
	# 1. If input is "invalid", cancel the slime launch.
	# 2. Drag angles cannot be made except in the direction of the field (not starting area)
	var area: Area2D = player_start_areas[clamp(turn - 1, 0, len(player_start_areas) - 1)] as Area2D
	var start_point = area.get_node("StartPoint") as Node2D
	var collider: CollisionShape2D = area.get_node("CollisionShape2D") as CollisionShape2D
	var shape: Rect2 = collider.shape.get_rect()
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	#region HANDLING PICKING UP A SLIME IF THERE IS NO ACTIVE SLIME
	# TODO: Clean up, refactor, and maybe extract
	if not (active_slime or held_slime) and Input.is_action_just_pressed("fire"):
		if cursor_area.has_overlapping_bodies():
			var slime = cursor_area.get_overlapping_bodies()[0] as Slime
			# We only want to be able to pick up slimes that are in the active player's starting area
			if slime not in player_start_areas[turn - 1].get_overlapping_bodies():
				return 
			held_slime = slime
			last_valid_slime_pos = held_slime.global_position
	if held_slime and Input.is_action_pressed("fire"):
		held_slime.trail.can_draw = false
		held_slime.global_position = mouse_pos
	elif held_slime and Input.is_action_just_released("fire"):
		# Check if the slime is over a starting line
		if held_slime.start_detection_area.has_overlapping_areas():
			active_slime = held_slime
			active_slime.global_position.x = start_point.global_position.x
		# If it isn't a valid position (starting area) reset it's position
		elif held_slime not in player_start_areas[turn - 1].get_overlapping_bodies():
			var tween = get_tree().create_tween()
			tween.tween_property(held_slime, "global_position", last_valid_slime_pos, 0.1)
		held_slime = null
		return
	#endregion
	
	#region HANDLING FOR WHEN SLIME IS IN START LINE READY TO BE DRAGGED
	if not Input.is_action_pressed("fire"):
		strength_bar_ui.visible = false
	if active_slime and Input.is_action_just_pressed("fire"):
		var selected_slimes = cursor_area.get_overlapping_bodies()
		if len(selected_slimes) > 0 and selected_slimes[0] != active_slime:
			var tween = get_tree().create_tween()
			tween.tween_property(active_slime, "global_position", last_valid_slime_pos, 0.1)
			active_slime = null
			held_slime = selected_slimes[0]
		can_drag =  cursor_area.has_overlapping_bodies() and\
					cursor_area.get_overlapping_bodies()[0] == active_slime
	if can_drag and active_slime and Input.is_action_just_released("fire"):
		if cursor_area.has_overlapping_bodies() and cursor_area.get_overlapping_bodies()[0] == active_slime:
			return # Cancel launch if mouse is still over the slime when let go
		state = ROUND.SLIMING
		timer.start(5)
		active_slime.trail.can_draw = true
		drag_line.visible = false
		can_drag = false
		launch_slime()
		return
	if can_drag and active_slime and Input.is_action_pressed("fire"):
		drag_line.visible = true
		drag_line.points[0] = Vector2(
			clamp(mouse_pos.x, active_slime.global_position.x - drag_line.MAX_LENGTH, active_slime.global_position.x + drag_line.MAX_LENGTH),
			clamp(mouse_pos.y, active_slime.global_position.y - drag_line.MAX_LENGTH, active_slime.global_position.y + drag_line.MAX_LENGTH)
		) # A bit verbose but basically the drag line cant be longer than it's max length
		drag_line.points[1] = active_slime.global_position
		
		# Also handle the 'power bar' asset's position, value, and visibility
		strength_bar_ui.visible = true
		strength_bar_ui.global_position = active_slime.global_position + Vector2(80,-80)
		strength_bar_ui.value = drag_line.strength * 100
	elif active_slime:
		drag_line.visible = false
		active_slime.global_position.y = clamp(mouse_pos.y, shape.size.y * -1 / 2, shape.size.y / 2)
		active_slime.position.x = start_point.position.x
	#endregion

func handle_sliming_state() -> void:
	# We start the next turn if all the slimes on the field are in the idle state
	# We have a timer the starts when a slime is launched so that we have a minimum turn length
	if not timer.is_stopped(): return
	for player in players:
		for slime in player.slimes_on_field:
			if slime.state_manager.state.name != "IDLE":
					return
	Globals.play_random_sfx(active_slime.audio_player, active_slime.slime_dizzys)
	next_turn()

func launch_slime() -> void:
	# TODO:
	# 1. Find way to prevent shooting into your own arena
	Globals.play_audio(FLICK_A_WET)
	launch_strength = drag_line.strength
	Globals.shake(0.19)
	Globals.zoom(Vector2(1.1,1.1), 0.3)
	var direction = 1 if get_global_mouse_position().x < active_slime.global_position.x else -1
	var strength = launch_strength * MAX_SPEED
	var angle = get_global_mouse_position().direction_to(active_slime.global_position)

	var x = strength * abs(angle.x) * direction
	var y = strength * angle.y
	active_slime.apply_impulse(Vector2(x, y))
	players[turn - 1].slimes_on_field.append(active_slime)
	swap_camera_to(active_slime)
	
	Globals.play_random_sfx(active_slime.audio_player, active_slime.slime_throws)

func swap_camera_to(target: Node2D = null):
	if target == null:
		camera_target = player_start_areas[turn - 1]
		return
	camera_target = target

func next_turn() -> void:
	print("Starting the next Turn")
	calculate_scores()
	players[turn - 1].remove_slime_from_roster(active_slime)
	active_slime = null
	
	turn += 1
	if turn > player_count:
		turn = 1
		rounds_elapsed += 1
		print("Rounds elapsed ", rounds_elapsed)
	if rounds_elapsed == MAX_SLIMES:
		state = ROUND.ENDING
		victory_ui.winner = get_winner()
		victory_ui.scores = [players[0].score, players[1].score]
		victory_ui.spawn_menu()
		return
	Globals.is_final_turn = rounds_elapsed == MAX_SLIMES - 1 and turn == player_count
	swap_camera_to(player_start_areas[turn - 1])
	Globals.zoom() # reset zoom if not default	
	state = ROUND.START

func calculate_scores() -> void:
	for player in players:
		player = player as Player
		var temp_score = 0
		for slime in player.slimes_on_field:
			slime = slime as Slime
			print("Slime for player ", player.player_num, " scored ", slime.calculate_score(), " points.")
			temp_score += slime.calculate_score()
		player.score = temp_score
		score_ui.set_score(player.player_num, player.score)
		print("player ", player.player_num, " score = ", player.score)

func get_winner() -> Player:
	var current_winner: Player = players[0]
	for player in players:
		if player.score > current_winner.score:
			current_winner = player
	return current_winner

func on_slime_impact(slime: Slime) -> void:
	# TODO: Rethink how to do this cleanly or remove
	# Currently runs when a slime hits another slime and we check if it's
	# the last throw of the game to do a dramatic time slow on impact.
	# The issues arising being concurrent freeze frames/zooms interact with each other
	# as well as not great ways of communicating between nodes.

	if slime != active_slime: return
	if not (rounds_elapsed == MAX_SLIMES - 1 and turn == player_count): return

	Globals.zoom(Vector2(1.4, 1.4), 0.20)
	Globals.freeze_frame(0.25, 1)
	await get_tree().create_timer(0.5).timeout
	Globals.zoom(Vector2(1.1,1.1), 0.2)
