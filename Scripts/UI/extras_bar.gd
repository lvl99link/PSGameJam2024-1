extends HBoxContainer

@onready var full_screen_button: Button = %FullScreenButton
@onready var help_button: Button = %HelpButton

const TUTORIAL = preload("res://Prefabs/UI/tutorial.tscn")

func _on_full_screen_button_pressed() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_help_button_pressed() -> void:
	var canvas = CanvasLayer.new()
	var tutorial_scene = TUTORIAL.instantiate()
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS
	get_window().add_child(canvas)
	canvas.add_child(tutorial_scene)
