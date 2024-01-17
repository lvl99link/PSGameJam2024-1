class_name StrengthLine
extends Line2D

const MAX_LENGTH = 200 # Fine tune

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
	current_length = points[0].distance_to(points[1])
	strength = clamp(current_length / MAX_LENGTH, 0, 1)
	default_color = Color(strength, 1 - strength, 0)
