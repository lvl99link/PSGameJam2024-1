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
	pass

func enter(_msg := {}) -> void:
	# When we enter the idle state
	# Play (and loop) the idle animation when idling.
	pass

func exit() -> void:
	pass
