class_name StateMachine
extends Node

signal transitioned(state_name)

export (NodePath) var initial_state

var state: State # This will be the current_state

func _ready():
	yield(owner, "ready")
	for child in get_children():
		child.state_machine = self
	state = get_node(initial_state)
	state.enter()

func _physics_process(delta):
	state.physics_update(delta)

func _process(delta):
	state.update(delta)

func _unhandled_input(event):
	state.handle_input(event)

func get_state() -> String:
	return state.name

func get_states() -> Array:
	var state_names: Array
	for child in get_children():
		state_names.append(child.name)
	return state_names

func transition_to(new_state: String, msg: Dictionary = {}):
	if not has_node(new_state):
		print("No state named: ", new_state)
		return 
	
	state.exit()
	state = get_node(new_state)
	state.enter(msg)
	emit_signal("transitioned", state.name)

