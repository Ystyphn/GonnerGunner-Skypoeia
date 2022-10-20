class_name EntityClass
extends KinematicBody2D


export (String) var id
export (int) var walk_speed = 85
export (int) var fall_speed = 60
export (int) var run_speed = 125
export (float) var jump_strength = 350.0
export (float) var health = 200.0
export (float) var armor_health = 0.0
export (float) var damage_reduction = 0.0
export (NodePath) var state_machine_path

var velocity: Vector2
var ship_relative_position: Vector2 # This will be the relative position
# of this entity to the ship. This will be reset if this entity exits the
# passenger area. This also should be updated every physics frames.
# So technically, the ship should keep in mind the position of every crew

onready var state_machine: StateMachine = get_node(state_machine_path)


func apply_damage(damage: Dictionary = {}):
	# Since I don't know how to pass damage datas yet, I assume that I will use
	# dictionary for it
	pass

func execute_special(data: Dictionary = {}):
	# This will be executed whenever you want
	pass

func reposition(reference):
	var temp_rel_pos = ship_relative_position
	temp_rel_pos = Vector2(round(temp_rel_pos.x), round(temp_rel_pos.y))
	var global_relative_pos = reference.to_global(temp_rel_pos)
	global_position.x = global_relative_pos.x
