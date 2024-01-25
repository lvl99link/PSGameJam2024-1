class_name StrengthLine
extends Line2D

const MAX_LENGTH = 325 # Fine tune

const SLIME_STRETCH_1 = preload("res://Assets/SFX/OGG/Slime_Stretch_1.ogg")

var current_length: float
var strength: float = 0
var can_play_stretch: bool = true 

func _ready() -> void:
	z_index = 1
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
	
	if can_play_stretch and strength > 0.2:
		Globals.play_audio(SLIME_STRETCH_1)
		can_play_stretch = false
	if not can_play_stretch and strength < 0.2: can_play_stretch = true
	
	current_length = clamp(points[0].distance_to(points[1]), 0, MAX_LENGTH)
	strength = clamp(current_length / MAX_LENGTH, 0, 1)
	default_color = Color(strength, 1 - strength, 0)
