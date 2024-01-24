extends Node

# Globally accessible singleton functions and variables should be set and defined here
# Sure it's probably better to split responsibility into multiple but this is fine for now.

var camera: CustomCamera = null
var FRICTION: float = 1
var slime_count = 3

var music_volume: float = 0.5
var sfx_volume: float = 0.5

var is_final_turn: bool = false # Don't really like this

func _ready() -> void:
	set_volume("Music", music_volume)
	set_volume("SFX", sfx_volume)

# Maybe move this to a global audio manager autoload script
func play_random_sfx(player: AudioStreamPlayer2D, sfx_arr: Array[AudioStreamOggVorbis]) -> void:
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, len(sfx_arr) - 1)
	player.stream = sfx_arr[idx]
	player.play()

func play_audio(file: AudioStream, mixer: String = "SFX", volume: float = 1) -> void:
	# given a preloaded soundfile, generate an audio stream player, spawn it
	# load the file, play it, and then destroy the player.
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = file
	audio_player.bus = mixer
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()

func set_volume(mixer: String, volume: float) -> float:
	var bus_idx = AudioServer.get_bus_index(mixer)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))
	return volume

func toggle_audio_effect(mixer: String, effect_idx: int, enabled=true) -> void:
	var bus_idx = AudioServer.get_bus_index(mixer)
	AudioServer.set_bus_effect_enabled(bus_idx, effect_idx, enabled)

func zoom(value: Vector2 = Vector2.ONE, zoom_time: float = 0.5):
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", value, zoom_time).set_ease(Tween.EASE_IN_OUT)

func shake(amount) -> void:
	# Helper shake function that calls the camera's shake function
	# Not necessary but only doing this for autocomplete
	# Suggested shake amount between 0.2 and 0.3. Get's really intense beyond that.
	camera.shake(amount)

func freeze_frame(timescale: float, duration: float) -> void:
	# Function that 'stops' time for a very brief moment.
	# Timescale is how slow you want the game to run (0.5 for half speed etc)
	# Duration is how long you want it to remain that way
	# Note that timescale must be > 0, as time will never resume if the engine has stopped counting
	Engine.time_scale = timescale
	#PhysicsServer2D.set_active(false)
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0
	#PhysicsServer2D.set_active(true)
