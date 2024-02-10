class_name SlimeBase
extends Resource

# This is an ABSTRACT BASE CLASS for other slime types to inherit
# All variables and functions pertaining specifically to a slime is set here
# and the inheriting classes will override them.
# YOU DO NOT CHANGE ANYTHING IN THIS CLASS except to add new variables/features

#region IMPORT ALL SLIME SOUND RELATED AUDIO SFX
const SLIME_A_IMPACT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_A.ogg")
const SLIME_A_IMPACT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_B.ogg")
const SLIME_A_IMPACT_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_C.ogg")
const SLIME_A_IMPACT_D = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_D.ogg")

const SLIME_A_SELECT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_A.ogg")
const SLIME_A_SELECT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_B.ogg")

const SLIME_A_THROW_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Throw_A.ogg")

const SLIME_A_DIZZY_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_A.ogg")
const SLIME_A_DIZZY_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_B.ogg")
const SLIME_A_DIZZY_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_C.ogg")

const SLIME_A_HAHA = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Haha.ogg")
const SLIME_A_SURPRISE_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_A.ogg")
const SLIME_A_SURPRISE_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_B.ogg")
const SLIME_A_SURPRISE_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_C.ogg")

const SLIME_SLIDE_BASE = preload("res://Assets/SFX/OGG/slime_slide_BASE.ogg")
const SLIME_IMPACT_SLAP = preload("res://Assets/SFX/OGG/Impacts/Slime_impact_slap.ogg")
const ICE_SLIDE_BASE = preload("res://Assets/SFX/OGG/ice_slide_BASE.ogg")
#endregion

#region CONSTRUCT SFX VARIANT ARRAYS
@export var slime_impacts: Array[AudioStreamOggVorbis] = [
	SLIME_A_IMPACT_A,
	SLIME_A_IMPACT_B,
	SLIME_A_IMPACT_C,
	SLIME_A_IMPACT_D
]
@export var slime_selects: Array[AudioStreamOggVorbis] = [
	SLIME_A_SELECT_A,
	SLIME_A_SELECT_B
]
@export var slime_throws: Array[AudioStreamOggVorbis] = [
	SLIME_A_THROW_A,
	SLIME_A_IMPACT_A,
	SLIME_A_IMPACT_B,
	SLIME_A_IMPACT_C,
	SLIME_A_IMPACT_D
]
@export var slime_dizzys: Array[AudioStreamOggVorbis] = [
	SLIME_A_DIZZY_A,
	SLIME_A_DIZZY_B,
	SLIME_A_DIZZY_C
]
@export var slime_surprised: Array[AudioStreamOggVorbis] = [
	SLIME_A_SURPRISE_A,
	SLIME_A_SURPRISE_B,
	SLIME_A_SURPRISE_C
]
#endregion

## The AnimatedSprite2D Node to assign to the slime
## Contains all the animations
@export var sprite: SpriteFrames

## The image to apply to the trails left behind by a slime
@export var trail_texture: Texture2D

## The image to apply to every particle that emits from the slime
@export var particle_texture: Texture2D

## Friction coefficient to apply to a slime that moves across this slimes trail
@export var trail_friction: float = 1.4

## Friction coefficient for the slime moving normally across a surface
@export var slime_friction: float = 1.0

## The default multiplier a new slime of this type should have
@export var base_multiplier: int = 4

func trail_behavior(_slime: Slime) -> void:
	# Implement default behavior for when the slime overlaps this slime's trail
	# Other slimes can overwrite this virtual function.
	pass
