extends Control

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/prototyping_level.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
