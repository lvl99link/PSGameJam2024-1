extends Control

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton

@onready var full_screen_button: Button = %FullScreenButton
@onready var help_button: Button = %HelpButton

const TUTORIAL = preload("res://Prefabs/UI/tutorial.tscn")

func _on_play_button_pressed() -> void:
	var PROTOTYPING_LEVEL = load("res://Scenes/prototyping_level.tscn") # change to main scene
	SceneTransition.change_scene(PROTOTYPING_LEVEL)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_full_screen_button_pressed() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_help_button_pressed() -> void:
	var tutorial_scene = TUTORIAL.instantiate()
	add_child(tutorial_scene)

