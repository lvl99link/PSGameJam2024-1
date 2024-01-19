class_name StateMachine
extends Node

# NOTE
# Attach this script to a node as a child of the node whose state you want to track.
# Each child of this 'StateMachine' node MUST have a script that implements the State class
# Example:
# Slime
# - Sprite2D
# - StateManager 	[Uses this Script]
# - - IDLE			[Uses custom script SlimeIdleState that extends State]
# - - SLIDING		[Uses custom script SlimeSlidingState that extends State]
# etc.
# WARNING: You do not change this script. It's just a manager. Logic goes in the custom State scripts.

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state := NodePath()

# Manually import the Slime this machine belongs to. Yes this makes it less "generic", but that's a future problem.
@export var parent: Slime

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: State = get_node(initial_state)
@onready var DEBUG_STATE_LABEL: Label = $"../DEBUGGING_STATE_LABEL"

var previous_state: State = null

func _ready() -> void:
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()
	# WARNING: FOR DEBUGGING REMOVE LATER
	DEBUG_STATE_LABEL.text = initial_state

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	previous_state = state

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	# WARNING: FOR DEBUGGING REMOVE LATER	
	DEBUG_STATE_LABEL.text = state.name
	emit_signal("transitioned", state.name)
