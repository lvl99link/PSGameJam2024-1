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

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var slime_audio_player: AudioStreamPlayer2D = $SlimeTrailAudioPlayer
@onready var trail: Trail = $Node2D/Trail
@onready var child_container: Node2D = $Node2D # Can't resize rigidbodies, so make a container to resize their children

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var trail_detection_area: Area2D = $Node2D/TrailDetectionArea
@onready var score_detection_area: Area2D = $Node2D/ScoreDetectionArea
@onready var start_detection_area: Area2D = $Node2D/StartLineDetectionArea

var multiplier: int = 4
var owned_by: Player
var can_move: bool = false # Probably unnecessary

func _ready() -> void:
	linear_damp = Globals.FRICTION

func _process(_delta: float) -> void:
	handle_slime_trail_friction()
	handle_sliming_audio()

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
				linear_damp = Globals.FRICTION * 3
	else:
		linear_damp = Globals.FRICTION
	
func calculate_score() -> int:
	var targets = score_detection_area.get_overlapping_areas()
	if len(targets) > 0:
		return (targets[0] as Target).value * multiplier
	return 0

func split() -> void:
	if multiplier <= 1: return
	# Function handles the 'splitting' of a slime when impacted by another
	# Reduce the slime's physical scale by half
	child_container.scale /= 2
	collider.scale /= 2
	mass /= 2
	# Reduce the slime's multiplier by half
	multiplier /= 2
	# Offset the slime's position by half it's width
	# Spawn another instance of this right beside it
	#var new_slime: Slime = duplicate() as Slime
	#new_slime.multiplier = multiplier
	#get_parent().add_child(duplicate())
	Globals.play_random_sfx(audio_player, slime_impacts)
	
func _on_body_entered(body: Slime) -> void:
	if abs(body.linear_velocity.x) < 10: return
	split()
