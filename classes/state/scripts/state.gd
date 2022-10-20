class_name State
extends Node

var state_machine

func _ready():
	pass

func enter(msg:={}):
	# Anything that is related to the root of the statemachine will be reseted
	# upon call of this method
	pass

func exit():
	# As what its name implies, yes it is for exiting
	# I currently don't find it useful yet
	pass

func physics_update(delta):
	pass

func update(delta):
	pass

func handle_input(event):
	pass
