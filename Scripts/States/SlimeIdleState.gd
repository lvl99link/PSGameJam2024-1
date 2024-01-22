extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	# Maybe we can randomly 'pace'. Switch to pacing state and then
	# switch back. Have a cooldown for how often it happens.
	pass

func physics_update(_delta: float) -> void:
	# We actually want to check our velocity constantly so that we know
	# to switch to the 'sliming' state if we detect that they have been moved.
	# This is a generic catch all to trigger animations and sounds when hit or launched
	# or otherwise moved unexpectedly from the idle state.
	var slime = state_machine.parent as Slime
	var speed = sqrt( pow(slime.linear_velocity.x, 2) + pow(slime.linear_velocity.y, 2))
	
	if speed > 10:
		state_machine.transition_to("SLIMING")

func enter(_msg := {}) -> void:
	# When we enter the idle state
	# Play (and loop) the idle animation when idling.
	if state_machine.parent.sprite:
		state_machine.parent.sprite.play("default")

func exit() -> void:
	pass
