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
@onready var trail: Trail = $Node2D/Trail
@onready var child_container: Node2D = $Node2D # Can't resize rigidbodies, so make a container to resize their children
@onready var collider: CollisionPolygon2D = $CollisionPolygon2D
@onready var detection_area: Area2D = $Node2D/DetectionArea

var multiplier: int = 4
var owned_by: Player
var can_move: bool = false # Probably unnecessary

func _ready() -> void:
	linear_damp = Globals.FRICTION

func _process(_delta: float) -> void:
	# Applies greater friction if the given slime is overlapping a slime trail
	for area in detection_area.get_overlapping_areas():
		if area and area != trail.collision_area:
			linear_damp = Globals.FRICTION * 20
		else:
			linear_damp = Globals.FRICTION

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
	
func _on_body_entered(body: Slime) -> void:
	if abs(body.linear_velocity.x) < 10: return
	split()
