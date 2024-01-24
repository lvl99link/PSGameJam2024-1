extends Node
# This autoload script automatically attached listeners to every button
# in the scene or gets added to the scene so that we can control the button
# hover and click sound effects from one place.

const BUTTON_A = preload("res://Assets/SFX/OGG/Buttons/button_A.ogg")
const BUTTON_B = preload("res://Assets/SFX/OGG/Buttons/button_B.ogg")
const BUTTON_C = preload("res://Assets/SFX/OGG/Buttons/button_C.ogg")

const BUTTON_CLICK_A = preload("res://Assets/SFX/OGG/Buttons/button_click_A.ogg")
const BUTTON_CLICK_B = preload("res://Assets/SFX/OGG/Buttons/button_click_B.ogg")

const BUTTON_HOVERS = [BUTTON_A, BUTTON_B, BUTTON_C]
const BUTTON_CLICKS = [BUTTON_CLICK_A, BUTTON_CLICK_B]

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node:Node) -> void:
	if node is Button:
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)

func _play_hover() -> void:
	var sound = BUTTON_HOVERS[randi() % BUTTON_HOVERS.size()]
	Globals.play_audio(sound, "SFX", 0.25)

func _play_pressed() -> void:
	var sound = BUTTON_CLICKS[randi() % BUTTON_CLICKS.size()]
	Globals.play_audio(sound)
