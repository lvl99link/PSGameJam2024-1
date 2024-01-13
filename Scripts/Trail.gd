class_name Trail
extends Node

@onready var curve: Curve2D = Curve2D.new()
@onready var parent: Node2D = $"../"
@onready var line: Line2D = $TrailLine

func _process(_delta: float) -> void:
	if line.get_point_count() > 0 and parent.position.distance_to(line.points[line.get_point_count()-1]) < 10:
		return
	curve.add_point(parent.position)
	line.points = curve.get_baked_points()
