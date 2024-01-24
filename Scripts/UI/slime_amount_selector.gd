extends Control

const MAX = 8
const MIN = 3

@onready var minus_button: Button = %MinusButton
@onready var slime_count_label: Label = %SlimeCountLabel
@onready var add_button: Button = %AddButton

var selected_number: int = 4

func _ready() -> void:
	slime_count_label.text = str(selected_number)

func _on_add_button_pressed() -> void:
	change_value(1)

func _on_minus_button_pressed() -> void:
	change_value(-1)

func change_value(value: int) -> void:
	selected_number = clamp(selected_number + value, MIN, MAX)
	minus_button.disabled = selected_number <= MIN
	add_button.disabled = selected_number >= MAX
	Globals.slime_count = selected_number
	slime_count_label.text = str(selected_number)
