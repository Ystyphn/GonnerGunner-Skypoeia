extends Node2D


var nozzle: Node2D

onready var ke_turret: Node = get_parent()


func set_target(target_: Node2D):
	nozzle.target = target_

func remove_target():
	nozzle.target = null
