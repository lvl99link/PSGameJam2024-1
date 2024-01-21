extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	# Maybe we can randomly 'pace'. Switch to pacing state and then
	# switch back. Have a cooldown for how often it happens.
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	# Play the dizzy animation.
	# Play dizzy sfx.
	# await the animation to finish before transitioning back to idle.
	pass

func exit() -> void:
	pass
