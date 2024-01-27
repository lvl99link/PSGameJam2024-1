extends State

func update(_delta: float) -> void:
	var hand = state_machine.parent as Hand
	hand.global_position = hand.get_global_mouse_position()

func physics_update(_delta: float) -> void:
	pass

func enter(_msg := {}) -> void:
	#var slime = state_machine.parent as Slime
	pass


func exit() -> void:
	pass
