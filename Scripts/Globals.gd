extends Node

var camera: CustomCamera = null
var FRICTION = 1

# Maybe move this to a global audio manager autoload script
func play_random_sfx(player: AudioStreamPlayer2D, sfx_arr: Array[AudioStreamOggVorbis]) -> void:
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, len(sfx_arr) - 1)
	player.stream = sfx_arr[idx]
	player.play()

func shake(amount) -> void:
	# Helper shake function that calls the camera's shake function
	# Not necessary but only doing this for autocomplete
	# Suggested shake amount between 0.05 and 0.3. Get's really intense beyond that.
	camera.shake(amount)

func freeze_frame(timescale: float, duration: float) -> void:
	# Function that 'stops' time for a very brief moment.
	# Timescale is how slow you want the game to run (0.5 for half speed etc)
	# Duration is how long you want it to remain that way
	# Note that timescale must be > 0, as time will never resume if the engine has stopped counting
	Engine.time_scale = timescale
	PhysicsServer2D.set_active(false)
	await get_tree().create_timer(duration * timescale).timeout
	Engine.time_scale = 1.0
	PhysicsServer2D.set_active(true)
