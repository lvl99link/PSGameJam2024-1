extends State

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	# When we start pacing, run the pacing animation (once?)
	# Apply a very small force in a random direction to simulate it moving
	# Once the animation stops playing, transition back to idle
	pass

func exit() -> void:
	pass
