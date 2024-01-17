class_name ScoreUI
extends Control

@onready var p1_score_label = $MarginContainer/Player1Score
@onready var p2_score_label = $MarginContainer/Player2Score 

var score_labels: Array[Label]

func _ready() -> void:
	score_labels = [
		p1_score_label,
		p2_score_label
	]
	
	set_score(1, 0)
	set_score(2, 0)

func set_score(player: int, value: int) -> void:
	score_labels[player - 1].text = str(value)
