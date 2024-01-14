class_name Slime
extends RigidBody2D

@onready var trail: Trail = $Trail

var multiplier: int = 4
var owned_by: Player
var can_move: bool = false # Probably unnecessary

func _ready() -> void:
	get_tree().get_first_node_in_group("GameManager")
	linear_damp = Globals.FRICTION

func _process(_delta: float) -> void:
	pass
	#if can_move:
		#print(linear_velocity)

func split() -> void:
	if multiplier == 1: return
	# Function handles the 'splitting' of a slime when impacted by another
	# Reduce the slime's physical scale by half
	scale /= 2
	# Reduce the slime's multiplier by half
	multiplier /= 2
	# Offset the slime's position by half it's width
	# Spawn another instance of this right beside it
	
