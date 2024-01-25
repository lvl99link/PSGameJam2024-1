extends Control

@onready var tutorial_image: TextureRect = %TutorialImage

@onready var next: Button = %Next
@onready var previous: Button = %Previous
@onready var close: Button = %Close

const TUTORIAL_1 = preload("res://Assets/Tutorial/tutorial_1.svg")
const TUTORIAL_2 = preload("res://Assets/Tutorial/tutorial_2.svg")
const TUTORIAL_3 = preload("res://Assets/Tutorial/tutorial_3.svg")
const TUTORIAL_4 = preload("res://Assets/Tutorial/tutorial_4.svg")
const TUTORIAL_5 = preload("res://Assets/Tutorial/tutorial_5.svg")

var slides = [
	TUTORIAL_1,
	TUTORIAL_2,
	TUTORIAL_3,
	TUTORIAL_4,
	TUTORIAL_5
]

var current_slide: int = 0

func _ready() -> void:
	z_index = 5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_parent().queue_free()

func change_slide(amount: int):
	if current_slide + amount < 0 or current_slide + amount > len(slides) - 1:
		return
	current_slide = clamp(current_slide + amount, 0, len(slides) - 1)
	tutorial_image.texture = slides[current_slide]	

func _on_next_pressed() -> void:
	change_slide(1)

func _on_previous_pressed() -> void:
	change_slide(-1)

func _on_close_pressed() -> void:
	get_parent().queue_free() # Delete the canvas item
