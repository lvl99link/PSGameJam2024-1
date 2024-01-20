extends Control

const PREVIEW_SFX = preload("res://Assets/SFX/OGG/Buttons/button_A.ogg")

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	music_slider.set_value_no_signal(Globals.music_volume)
	sfx_slider.set_value_no_signal(Globals.sfx_volume)

func _on_play_button_pressed() -> void:
	# I really want to start some persistent animation, switch scenes, and then
	# end the animation for a buttery smooth transition. 
	# 1. Set up some animation player to do something
	# 2. Run animation (transition to)
	# 3. Switch the scene
	# 4. Once the scene is fully loaded, finish the animation (play transition_from)
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_music_slider_value_changed(value: float) -> void:
	Globals.set_volume("Music", value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Globals.set_volume("SFX", value)
	Globals.play_audio(PREVIEW_SFX)
