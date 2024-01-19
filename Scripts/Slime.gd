class_name Slime
extends RigidBody2D

#region IMPORT ALL SLIME SOUND RELATED AUDIO SFX
const SLIME_A_IMPACT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_A.ogg")
const SLIME_A_IMPACT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_B.ogg")
const SLIME_A_IMPACT_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_C.ogg")
const SLIME_A_IMPACT_D = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_D.ogg")
const SLIME_A_SELECT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_A.ogg")
const SLIME_A_SELECT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_B.ogg")
const SLIME_A_THROW_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Throw_A.ogg")
const SLIME_A_DIZZY_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_A.ogg")
const SLIME_SLIDE_BASE = preload("res://Assets/SFX/OGG/slime_slide_BASE.ogg")
#endregion

#region CONSTRUCT SFX VARIANT ARRAYS
@onready var slime_impacts: Array[AudioStreamOggVorbis] = [
	SLIME_A_IMPACT_A,
	SLIME_A_IMPACT_B,
	SLIME_A_IMPACT_C,
	SLIME_A_IMPACT_D
]
@onready var slime_selects: Array[AudioStreamOggVorbis] = [
	SLIME_A_SELECT_A,
	SLIME_A_SELECT_B
]
@onready var slime_throws: Array[AudioStreamOggVorbis] = [
	SLIME_A_THROW_A
]
@onready var slime_dizzys: Array[AudioStreamOggVorbis] = [
	SLIME_A_DIZZY_A
]
#endregion

@onready var state_manager: StateMachine = $StateManager
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var slime_audio_player: AudioStreamPlayer2D = $SlimeTrailAudioPlayer
@onready var trail: Trail = $Node2D/Trail
@onready var child_container: Node2D = $Node2D # Can't resize rigidbodies, so make a container to resize their children
@onready var split_cooldown_timer: Timer = $SplitCooldownTimer

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var trail_detection_area: Area2D = $Node2D/TrailDetectionArea
@onready var score_detection_area: Area2D = $Node2D/ScoreDetectionArea
@onready var start_detection_area: Area2D = $Node2D/StartLineDetectionArea
@onready var slime_detection_area: Area2D = $Node2D/SlimeDetectionArea

var owned_by: Player
var multiplier: int = 4
var slime_friction: float = 1.25
var can_split: bool = true

func _ready() -> void:
	linear_damp = Globals.FRICTION

func _physics_process(_delta: float) -> void:
	handle_slime_trail_friction()
	handle_sliming_audio()
	# Resets the can_split once it's had a moment to settle down
	if not can_split and linear_velocity.x < 10:
		await get_tree().create_timer(1).timeout
		if linear_velocity.x < 10: can_split = true

func handle_sliming_audio() -> void:
	if linear_velocity.x > 5 and not slime_audio_player.playing:
		slime_audio_player.stream = SLIME_SLIDE_BASE
		slime_audio_player.play()
	elif linear_velocity.x <=5 and slime_audio_player.playing:
		slime_audio_player.stop()

func handle_slime_trail_friction() -> void:
	# Applies greater friction if the given slime is overlapping a slime trail
	# NOTE: Slime is not slowed down by its own slime trail. Could be a feature or a bug.
	# 		Don't want it to be slowed by its own trail as its launched.
	var trails = trail_detection_area.get_overlapping_areas()
	if len(trails) > 0:
		for t in trails:
			if t != trail.collision_area:
				linear_damp = Globals.FRICTION * slime_friction
	else:
		linear_damp = Globals.FRICTION
	
func calculate_score() -> int:
	# Gets all the 'score areas' that the slime might be overlapping
	var targets = score_detection_area.get_overlapping_areas()
	if len(targets) > 0:
		# TODO: Only gets the first overlapping area. Maybe better way to pick.
		return (targets[0] as Target).value * multiplier
	return 0

func split(hit_vector: Vector2 = Vector2.ZERO) -> void:
	# Function handles the 'splitting' of a slime when impacted by another
	# Resizes and adjusts properties before 'cloning' the instance
	# Instance is instantiated with some repositioning based on the vector
	# perpendicular to the direction it was hit from
	# TODO: Apply impulse at an angle so they split away from each other for more
	#		fun unpredictability. Currently they split and move in the same direction.
	if multiplier <= 1: return
	
	child_container.scale *= 0.65
	collider.scale *= 0.65
	mass /= 2
	multiplier /= 2
	can_split = false
	
	var perpendicular = Vector2(hit_vector.y, -hit_vector.x)
	var height = collider.shape.get_rect().size.x/3
	var new_slime = clone()
	global_position += height * perpendicular
	new_slime.global_position -= height * perpendicular
	call_deferred("spawn", new_slime)
	
	Globals.play_random_sfx(audio_player, slime_impacts)

func _on_slime_detection_area_body_entered(body: Slime) -> void:
	if body == self: return
	if multiplier <= 1: return
	if not can_split: return 
	
	var directional_velocity = sqrt(pow(linear_velocity.x, 2) + pow(linear_velocity.y, 2))
	if abs(directional_velocity) < 300: return
	Globals.freeze_frame(0.05, 0.15)
	Globals.shake(0.2)

	state_manager.transition_to("IMPACTING")
	var hit_vector = body.global_position.direction_to(global_position)
	split(hit_vector)

func clone() -> Slime:
	# Function creates and returns a fully contstructed clone of the current instance of this slime
	# It has to set each variable in this script manually, else it'll be null
	# I'm honestly not sure which types of values *need* to be set. This seems to work fine for now.
	var new_slime = duplicate(5) as Slime
	new_slime.owned_by = owned_by
	new_slime.multiplier = multiplier
	new_slime.can_split = false
	new_slime.trail = trail.duplicate(5) as Trail
	owned_by.slimes_on_field.append(new_slime)
	
	return new_slime

func spawn(new_slime: Slime) -> void:
	get_parent().add_child(new_slime)
	new_slime.trail.can_draw = true
