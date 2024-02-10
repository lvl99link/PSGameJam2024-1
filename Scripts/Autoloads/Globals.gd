extends Node

# Globally accessible singleton functions and variables should be set and defined here
# Sure it's probably better to split responsibility into multiple but this is fine for now.

var camera: CustomCamera = null

var player_count = 2
var slime_count = 4

var is_final_turn: bool = false # Don't really like this
var previous_menu: Control = null # Stores reference to the previously active UI node

const slime_color_by_player: Array[Color] = [ # Slime sprite modulation colors
	Color(0.36, 0.98, 0.23, 0.7), # Green
	Color(1, 0.3, 0.16, 0.7), # Red
	Color(0.13, 0.59, 0.71, 0.7), # Blue
	Color(0.8, 0.67, 0.1, 0.7)  # Yellow
]

const trail_color_by_player: Array[Color] = [ # Slime trail colors
	Color(0, 1, 0, 0.7), # Green
	Color(1, 0, 0, 0.7), # Red
	Color(0, 0, 1, 0.7), # Blue
	Color(1, 1, 0, 0.7)  # Yellow
]

# Maybe move this to a global audio manager autoload script
func play_random_sfx(sfx_arr: Array[AudioStreamOggVorbis]) -> void:
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, len(sfx_arr) - 1)
	play_audio(sfx_arr[idx])

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

func change_menu(from: Control, to: Control) -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.tween_property(from, "position:x", -1920, 0.25).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(to, "position:x", 0, 0.25).set_ease(Tween.EASE_IN_OUT)
	previous_menu = from
