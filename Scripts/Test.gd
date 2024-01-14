extends Sprite2D

# TEST SCRIPT DELETE THIS #

@export var start_line: Node2D



func _process(_delta: float) -> void:
	# only do this while round is in the starting state
	# bound the y position to not go past the bounds
	# on click, change the game state
	position.y = get_global_mouse_position().y
	position.x = start_line.position.x
