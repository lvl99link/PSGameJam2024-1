class_name ScoreUI
extends Control

@onready var player_1_score: Label = %Player1Score
@onready var player_2_score: Label = %Player2Score

@onready var slime_1_texture: TextureRect = %Slime1Texture
@onready var slime_2_texture: TextureRect = %Slime2Texture

@onready var slime_1_count: Label = %Slime1Count
@onready var slime_2_count: Label = %Slime2Count

@onready var score_labels: Array[Label] = [
	player_1_score,
	player_2_score
]
@onready var throws_labels: Array[Label] = [
	slime_1_count,
	slime_2_count
]
@onready var textures: Array[TextureRect] = [
	slime_1_texture,
	slime_2_texture
]

func _ready() -> void:
	set_score(1, 0)
	set_score(2, 0)
	
	set_throws_remaining(1, Globals.slime_count)
	set_throws_remaining(2, Globals.slime_count)
	
	set_slime_texture_color()

func set_score(player: int, value: int) -> void:
	score_labels[player - 1].text = str(value)

func set_throws_remaining(player: int, value: int) -> void:
	throws_labels[player - 1].text = "x" +str(value)

func set_slime_texture_color() -> void:
	for i in Globals.player_count:
		textures[i].modulate = Globals.slime_color_by_player[i]
	
