extends Control

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton
@onready var settings_button: Button = %SettingsButton

@onready var menu_content: Control = $MenuContent

var settings_menu_prefab = preload("res://Prefabs/UI/settings_menu.tscn")

func _ready() -> void:
	play_button.text = tr("MENU_LABEL_PLAY")
	exit_button.text = tr("MENU_LABEL_EXIT")
	settings_button.text = tr("MENU_OPTIONS")

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/prototyping_level.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	# Spawn in the settings menu
	var settings_menu = settings_menu_prefab.instantiate() as Control
	settings_menu.position.x = 1920
	add_child(settings_menu)
	
	Globals.change_menu(menu_content, settings_menu)
