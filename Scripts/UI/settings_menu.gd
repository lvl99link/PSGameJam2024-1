extends Control

func _on_back_button_pressed() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "position:x", 1920, 0.25).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Globals.previous_menu, "position:x", 0, 0.25).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()
