extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	var slime: Slime = state_machine.parent as Slime
	# Hacky fallback in case the animation desyncs from the state machine
	if slime.sprite.animation != "impact":
		state_machine.transition_to("SLIMING")

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	# Simply play the impacted animation 
	# We can move sound effects in here as well.
	# Then transition back to the previous state.
	var slime = state_machine.parent as Slime
	slime.hit_particles.emitting = true
	slime.sprite.play("impact")
	await slime.sprite.animation_finished
	state_machine.transition_to("SLIMING")

func exit() -> void:
	pass
