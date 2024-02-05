class_name UserSettings
extends Resource

# NOTE: Placeholder list of languages for localization
# Format of data structures subject to change based on finalized implementation (TODO)
const LANGUAGES_MAP = {
	"English": "en",
	"French": "fr",
	"Spanish": "es",
	"German": "de",
	"Italian": "it",
	"Portuguese": "pt",
	"Russian": "ru",
	"Greek": "el",
	"Turkish": "tr",
	"Danish": "da",
	"Norwegian": "no",
	"Swedish": "sv",
	"Dutch": "nl",
	"Polish": "pl",
	"Finnish": "fi",
	"Japanese": "ja",
	"Chinese": "zh",
	"Korean": "ko",
	"Czech": "cs",
	"Hungarian": "hu",
	"Romanian": "ro",
	"Thai": "th",
	"Bulgarian": "bg",
	"Hebrew": "he",
	"Arabic": "ar",
	"Bosnian": "bs",
}

# Audio
@export_range(0, 1, 0.01) var master_volume: float = 1.0
@export_range(0, 1, 0.01) var music_volume: float = 0.5
@export_range(0, 1, 0.01) var sfx_volume: float = 0.5

# Language
@export var language: String = "en"

func save() -> void:
	ResourceSaver.save(self, "user://user_settings.tres")

static func load_or_create() -> UserSettings:
	var res: UserSettings
	if ResourceLoader.exists("user://user_settings.tres"):
		res = load("user://user_settings.tres") as UserSettings
	else:
		res = UserSettings.new()
		#res.set_default_settings()
		ResourceSaver.save(res, "user://user_settings.tres")
	return res

#static func set_default_settings() -> void:
	#pass
