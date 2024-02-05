extends CanvasLayer

signal scene_changed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: String, animation: String = "Slide") -> void:
	# Asyncronously load the requested scene in a separate thread
	ResourceLoader.load_threaded_request(target)

	# Play the selected screen animation and wait for it to finish
	animation_player.play(animation)
	await animation_player.animation_finished
	
	# Load the new scene and change the current scene
	var scene = ResourceLoader.load_threaded_get(target)
	get_tree().change_scene_to_packed(scene)
	
	# Once the scene has been loaded, play the animation backwards to show the screen again
	animation_player.play_backwards(animation)
	await animation_player.animation_finished
	
	# Cleanup
	get_tree().paused = false # In case the game was unintentionally put in the pause state
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Make mouse visible, in case it wasn't
	Globals.toggle_audio_effect("Music", 0, false) # Remove low pass filter if kept on
	
	scene_changed.emit()
