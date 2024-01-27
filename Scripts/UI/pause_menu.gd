extends Control

@onready var resume_button: Button = %Resume
@onready var quit_button: Button = %Quit
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_paused()

func toggle_paused() -> void:
	var is_paused = not get_tree().paused # set local tracker variable to the new state we want
	get_tree().paused = is_paused # set the actual game state to the new state
	
	if is_paused:
		visible = true
		animation_player.play("enter")
		Globals.toggle_audio_effect("Music", 0, true)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		animation_player.play_backwards("enter")
		await animation_player.animation_finished
		visible = false
		Globals.toggle_audio_effect("Music", 0, false)

func _on_resume_pressed() -> void:
	# Play the exit animation, then destroy the scene (or set invsibile)
	toggle_paused()

func _on_quit_pressed() -> void:
	toggle_paused()
	var MAIN_MENU = load("res://Scenes/main_menu.tscn")
	SceneTransition.change_scene(MAIN_MENU)
