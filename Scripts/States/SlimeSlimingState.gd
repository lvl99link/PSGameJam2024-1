extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	# If we have not been moving for a few seconds, we can automatically transition
	# to the 'dizzy' state for a few seconds before automatically entering the idle state.
	if state_machine.parent.linear_velocity.x < 10:
		await get_tree().create_timer(2).timeout
		if state_machine.parent.linear_velocity.x < 10:
			state_machine.transition_to("IDLE")
	pass

func enter(_msg := {}) -> void:
	# When we enter the sliming state (manually set after the launch function)
	# Start playing the corresponding animations. Mainly the spinning loop.
	# However we can maybe chain that to run after the initial getting flicked animation.
	pass

func exit() -> void:
	pass
