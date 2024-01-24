class_name Target
extends Area2D

const SCORING_NOTE_BLUE = preload("res://Assets/SFX/OGG/Scoring/SCORING_NOTE_BLUE.ogg")
const SCORING_NOTE_RED = preload("res://Assets/SFX/OGG/Scoring/SCORING_NOTE_RED.ogg")
const SCORING_NOTE_YELLOW = preload("res://Assets/SFX/OGG/Scoring/SCORING_NOTE_YELLOW.ogg")

@export var value: int = 10
@export var allowed_multipliers: Array[int] = [1,2,4]
@export var collision_shape: CollisionObject2D

var score_notes = [SCORING_NOTE_BLUE, SCORING_NOTE_YELLOW, SCORING_NOTE_RED]

func calculate_scores() -> void:
	pass
