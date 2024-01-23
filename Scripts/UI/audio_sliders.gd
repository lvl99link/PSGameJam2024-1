extends GridContainer

const PREVIEW_SFX = preload("res://Assets/SFX/OGG/Buttons/button_A.ogg")

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	music_slider.set_value_no_signal(Globals.music_volume)
	sfx_slider.set_value_no_signal(Globals.sfx_volume)

func _process(_delta: float) -> void:
	if music_slider.value != Globals.music_volume:
		music_slider.set_value_no_signal(Globals.music_volume)
	if sfx_slider.value != Globals.sfx_volume:
		sfx_slider.set_value_no_signal(Globals.sfx_volume)

func _on_music_slider_value_changed(value: float) -> void:
	# I don't like that i have to set the bus volumes saved values
	# separately from the actual bus volumes. set_volume should handle all that
	# TODO: figure that out.
	Globals.music_volume = Globals.set_volume("Music", value)

func _on_sfx_slider_value_changed(value: float) -> void:
	Globals.sfx_volume = Globals.set_volume("SFX", value)
	Globals.play_audio(PREVIEW_SFX)
