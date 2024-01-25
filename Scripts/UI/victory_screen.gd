class_name VictoryUI
extends Control

const MAIN_MENU = preload("res://Scenes/main_menu.tscn")

@onready var blurred_background: ColorRect = %BlurredBackground
@onready var banner: ColorRect = %Banner

@onready var victory_label: Label = %VictoryLabel
@onready var score_label: Label = %ScoreLabel

@onready var menu_button: Button = %Menu
@onready var rematch_button: Button = %Rematch
@onready var exit_button: Button = %Exit
@onready var show_map: Button = %Show

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var winner: Player
var scores: Array[int] = [0,0]
var hide_banner: bool = false

func _ready() -> void:
	winner = Player.new()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

func spawn_menu() -> void:
	show_map.visible = false
	visible = true
	Globals.toggle_audio_effect("Music", 0, true)
	AudioManager.play(AudioManager.victory_music_player, 0.25)
	var color: Color = winner.color_by_player_num[winner.player_num - 1]
	if scores[0] == scores[1]:
		color = Color.DIM_GRAY
	
	victory_label.add_theme_color_override("font_color", color)
	score_label.add_theme_color_override("font_color", color)
	
	if scores[0] != scores[1]:
		victory_label.text = "Player " + str(winner.player_num) + " Wins!"
	else:
		victory_label.text = "Game Tied!"
	score_label.text = str(scores[0]) + " - " + str(scores[1])
	
	animation_player.play("Intro")
	await animation_player.animation_finished
	show_map.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_menu_pressed() -> void:
	Globals.toggle_audio_effect("Music", 0, false)
	SceneTransition.change_scene(MAIN_MENU)

func _on_rematch_pressed() -> void:
	Globals.toggle_audio_effect("Music", 0, false)
	var PROTOTYPING_LEVEL = load("res://Scenes/prototyping_level.tscn") # change to main scene
	SceneTransition.change_scene(PROTOTYPING_LEVEL)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_show_pressed() -> void:
	hide_banner = not hide_banner
	if hide_banner:
		Globals.toggle_audio_effect("Music", 0, false)
		show_map.text = "Back"
		animation_player.play_backwards("Intro")
	else:
		Globals.toggle_audio_effect("Music", 0, true)
		show_map.text = "Show Map"
		animation_player.play("Intro")
