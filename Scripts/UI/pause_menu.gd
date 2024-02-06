extends Control

@onready var resume_button: Button = %Resume
@onready var quit_button: Button = %Quit
@onready var options_button: Button = %Options
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var paused_label: Label = %PausedLabel

var settings_menu_prefab = preload("res://Prefabs/UI/settings_menu.tscn")

func _ready() -> void:
	paused_label.text = tr("MENU_LABEL_PAUSED")
	quit_button.text = tr("MENU_LABEL_RETURN_MAIN")
	options_button.text = tr("MENU_OPTIONS")
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
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")

func _on_options_pressed() -> void:
	var settings_menu = settings_menu_prefab.instantiate() as Control
	settings_menu.position.x = 1920
	add_child(settings_menu)
	
	Globals.change_menu(margin_container, settings_menu)
