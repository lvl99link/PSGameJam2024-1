class_name Target
extends Area2D

@export var value: int = 10

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# TODO: Load sounds that play when a score area is entered

func _on_slime_entered(_body: Node2D) -> void:
	# variably set the audio stream to play the sound associated with the score
	# the higher the score, the higher the pitch
	pass
