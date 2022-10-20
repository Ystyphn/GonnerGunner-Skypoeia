class_name PropulsionNode
extends Node2D


func set_engine_output(output):
	for propulsion in get_children():
		propulsion.set_engine_output(output)

func activate_propulsions(flag: bool):
	for propulsion in get_children():
		if flag:
			propulsion.set_state("Active")
		else:
			propulsion.set_state("Inactive")
