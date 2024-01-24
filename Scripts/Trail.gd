class_name Trail
extends Node

const MAX_WIDTH = 80

@export var width: float = 30
@export var resolution: int = 10

@onready var curve: Curve2D = Curve2D.new()
@onready var parent: Node2D = $"../"
@onready var line: Line2D = $TrailLine
@onready var collision_area: Area2D = $TrailLine/Area2D

var can_draw: bool = false

func _ready() -> void:
	line.width = width
	for n in collision_area.get_children():
		collision_area.remove_child(n)
		(n as Node2D).queue_free()

func _physics_process(_delta: float) -> void:
	if not can_draw: return
	if line.get_point_count() > 0 and parent.global_position.distance_to(line.points[line.get_point_count()-1]) < resolution:
		return

	curve.add_point(parent.global_position)
	line.points = curve.get_baked_points()
	
	var new_shape = CollisionShape2D.new()
	collision_area.add_child(new_shape)
	var segment = RectangleShape2D.new()
	new_shape.position = (line.points[line.get_point_count()-2] + line.points[line.get_point_count()-1]) / 2
	new_shape.rotation = line.points[line.get_point_count()-2].direction_to(line.points[line.get_point_count()-1]).angle()
	var length = line.points[line.get_point_count()-2].distance_to(line.points[line.get_point_count()-1])
	segment.size = Vector2((length + resolution), width)
	
	new_shape.shape = segment
