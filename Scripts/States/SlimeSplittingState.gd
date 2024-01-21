extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	# Simply play the impacted animation 
	# We can move sound effects in here as well.
	# Then transition back to the previous state.
	await get_tree().create_timer(1).timeout # in place of waiting for the animation until we get them
	state_machine.transition_to(state_machine.previous_state.name)
	pass

func exit() -> void:
	pass
