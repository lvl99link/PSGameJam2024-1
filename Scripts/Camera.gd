class_name CustomCamera
extends Camera2D

# I copied this basic implementation from online
# I'd like to fine tune and perfect this so that it feels satisfying without
# getting too crazy or jarring.

@export var decay = 0.5  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(75, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
@export var offset_limit = 8

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake_process()

func shake(amount):
	# Method to call externally to initialize a shake whenever you want.
	trauma = min(trauma + amount, 1.0)

func shake_process():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = clamp(max_offset.x * amount * randf_range(-1, 1), -offset_limit, offset_limit)
	offset.y = clamp(max_offset.y * amount * randf_range(-1, 1), -offset_limit, offset_limit)
