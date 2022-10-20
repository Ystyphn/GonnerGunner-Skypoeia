class_name TileDetectors
extends Node2D

var children: Array
var tile_detected_1: bool
var tile_detected_2: bool
var collision_point: Vector2

onready var parent: = get_parent()

func _ready():
	children = get_children()


func _physics_process(delta):
	if parent == null:
		return
	if parent.velocity.x < 0:
		scale.x = -1
	elif parent.velocity.x > 0:
		scale.x = 1
	
	for child in children:
		if child.name == "Detector1":
			tile_detected_1 = child.is_colliding()
		elif child.name == "Detector2":
			tile_detected_2 = child.is_colliding()
		else:
			print("No detector named: ", child.name, " registered in selection")
			print("Parent is ", parent.name)
			print("Terminating the program...")
			get_tree().quit()
	
	collision_point = children[1].get_collision_point()


func do_autojump():
	return !tile_detected_1 and tile_detected_2


func is_collision_on_dir(dir: int):
	if dir < 0:
		# left
		if parent.to_local(collision_point).x <= dir:
			# means collision is on left
			return true
		else:
			return false
	elif dir > 0:
		# right
		if parent.to_local(collision_point).x >= dir:
			# means collision in on right
			return true
		else:
			return false
	else:
		return true


func disable_raycasts():
	for child in children:
		child.set_enabled(false)


func enable_raycasts():
	for child in children:
		child.set_enabled(true)
