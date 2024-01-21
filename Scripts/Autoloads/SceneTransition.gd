extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: PackedScene, animation: String = "Slide") -> void:
	animation_player.play(animation)
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(target)
	animation_player.play_backwards(animation)
