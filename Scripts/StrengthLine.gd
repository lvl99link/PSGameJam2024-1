class_name StrengthLine
extends Line2D

const MAX_LENGTH = 300 # Fine tune

var current_length: float
var strength: float = 0

func _ready() -> void:
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

	var curve = Curve.new()
	curve.add_point(Vector2(0, 0.35))
	curve.add_point(Vector2.ONE)
	width_curve = curve
	
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	
	visible = false
	width = 25
	antialiased = true

func _process(_delta: float) -> void:
	if not visible: return
	print(current_length)
	current_length = clamp(points[0].distance_to(points[1]), 0, MAX_LENGTH)
	strength = clamp(current_length / MAX_LENGTH, 0, 1)
	default_color = Color(strength, 1 - strength, 0)
