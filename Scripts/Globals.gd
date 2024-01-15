extends Node

var FRICTION = 1

# Maybe move this to a global audio manager autoload script
func play_random_sfx(player: AudioStreamPlayer2D, sfx_arr: Array[AudioStreamOggVorbis]) -> void:
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, len(sfx_arr) - 1)
	player.stream = sfx_arr[idx]
	player.play()
