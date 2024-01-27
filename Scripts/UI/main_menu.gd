extends Control

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton

func _on_play_button_pressed() -> void:
	# TODO: Async load to prevent lag while scene is being loaded.
	var PROTOTYPING_LEVEL = load("res://Scenes/prototyping_level.tscn") # change to main scene
	SceneTransition.change_scene(PROTOTYPING_LEVEL)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
