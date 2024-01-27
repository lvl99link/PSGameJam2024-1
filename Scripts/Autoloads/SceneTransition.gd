extends CanvasLayer

signal scene_changed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: PackedScene, animation: String = "Slide") -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	animation_player.play(animation)
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(target)
	animation_player.play_backwards(animation)
	await animation_player.animation_finished
	get_tree().paused = false # In case the game was unintentionally put in the pause state
	Globals.toggle_audio_effect("Music", 0, false) # Remove low pass filter if kept on
	scene_changed.emit()
