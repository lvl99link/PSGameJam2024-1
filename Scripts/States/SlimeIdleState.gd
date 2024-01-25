extends State

const PACE_FORCE = 8
var timer: Timer

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
	
	if speed > 12:
		state_machine.transition_to("SLIMING")
		return
	
	# Randomly 'pace' in a random direction if idle and the slime is not on the field
	if timer.is_stopped() and slime not in slime.owned_by.slimes_on_field:
		var roll = randi_range(0, 10)
		if roll:
			slime.apply_impulse(Vector2(randi_range(-PACE_FORCE, PACE_FORCE), randi_range(-PACE_FORCE, PACE_FORCE)))
		timer.start(5)
		# Transition to pacing state
		# For now we can just play the pacing animation + sound since it's pretty simple

func enter(_msg := {}) -> void:
	# When we enter the idle state
	# Play (and loop) the idle animation when idling.
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(5)
	
	if state_machine.parent.sprite:
		state_machine.parent.sprite.play("default")

func exit() -> void:
	timer.stop()
	remove_child(timer)
	timer.queue_free()
