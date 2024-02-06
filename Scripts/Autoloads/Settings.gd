extends Node

# Purpose of this script is to read saved or default user settings and apply those 
# settings on load, as well as act as the central authority for changing any particular setting.
# NOTE: This script differs from the UserSettings in that UserSettings is a Resource that
# saves and loads to and from disk, while this Settings script applies the data to the game itself.
# It is basically a middleman that reads settings on startup and saves settings to disk when changed.

@onready var user_settings: UserSettings = UserSettings.load_or_create() as UserSettings

func _ready() -> void:
	set_default_audio_settings()

func set_default_audio_settings() -> void:
	# Reads the loaded values from the user settings and sets the bus values accordingly
	AudioManager.set_volume("Master", user_settings.master_volume)
	AudioManager.set_volume("Music", user_settings.music_volume)
	AudioManager.set_volume("SFX", user_settings.sfx_volume)

#region Audio Volume Settings
func set_master_volume(value: float) -> void:
	AudioManager.set_volume("Master", value)
	user_settings.master_volume = value
	user_settings.save()

func set_music_volume(value: float) -> void:
	AudioManager.set_volume("Music", value)
	user_settings.music_volume = value
	user_settings.save()
	
func set_sfx_volume(value: float) -> void:
	AudioManager.set_volume("SFX", value)
	user_settings.sfx_volume = value
	user_settings.save()
#endregion

func set_language(value: String) -> void:
	TranslationServer.set_locale(value)
	user_settings.language = value
	user_settings.save()
