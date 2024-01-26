extends State

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	print("dyzz")
	var slime = state_machine.parent as Slime
	Globals.play_random_sfx(slime.slime_dizzys)
	slime.sprite.play("dizzy")
	await slime.sprite.animation_finished
	print("animation finished?")
	state_machine.transition_to("IDLE")

func exit() -> void:
	pass
