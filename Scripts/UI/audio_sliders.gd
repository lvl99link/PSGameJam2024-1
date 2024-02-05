extends Control

const PREVIEW_SFX = preload("res://Assets/SFX/OGG/Buttons/button_A.ogg")

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	var user_settings: UserSettings = Settings.user_settings as UserSettings
	music_slider.set_value_no_signal(user_settings.music_volume)
	sfx_slider.set_value_no_signal(user_settings.sfx_volume)

func _on_music_slider_value_changed(value: float) -> void:
	Settings.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.set_sfx_volume(value)
	Globals.play_audio(PREVIEW_SFX)
