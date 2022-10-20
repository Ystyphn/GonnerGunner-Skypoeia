class_name WalkNCollide
extends EntityClass


export (float, 0.1, 1.0) var acceleration = 0.1
export (float) var autojump_strength = 115
export (float) var on_air_speed = 65

var target_queue: Array
var target: Object
var dir: int
var snap_vector: Vector2 = Vector2(0, 8)
var target_velocity: Vector2

var action_db: Array = ["Walk", "Idle"]

onready var detector_1: RayCast2D = $TileDetectors/Detector1
onready var detector_2: RayCast2D = $TileDetectors/Detector2
onready var tile_detectors: TileDetectors = get_node("TileDetectors")


func _ready():
	pass


func _unhandled_input(event):
	if target != null:
		return
	if event.is_action_pressed("ui_left"):
		dir = -1
	elif event.is_action_pressed("ui_right"):
		dir = 1
	elif event.is_action_pressed("ui_down"):
		dir = 0
	
	if event.is_action_pressed("ui_up"):
		set_state("Jump")


func _physics_process(delta):
	if target == null:
		return
	dir = get_target_dir()


func add_target(body):
	if body in target_queue:
		return
	if target == null:
		target = body
	else:
		if not body in target_queue:
			target_queue.append(body)


func pop_target(body):
	if target != null:
		if target == body:
			target = null
		if target_queue.size() > 0:
			target = target_queue.pop_front()
	if body in target_queue:
		target_queue.erase(body)
		return


func get_target_dir():
	if target == null:
		return
		
	var dir: int
	if target.global_position.x < global_position.x:
		dir = -1
	elif target.global_position.x > global_position.x:
		dir = 1
	else:
		dir = 0 
	return dir


func choose_action():
	# This will be called on ready of this body
	# This will also be called after a certain period of time
	pass


func choose_direction():
	# This will only be called if the chosen action is walk
	pass


func do_autojump():
	return tile_detectors.do_autojump()
	

func is_collision_on_dir(dir: int):
	return tile_detectors.is_collision_on_dir(dir)


func set_state(new_state: String):
	state_machine.transition_to(new_state)


func get_state() -> String:
	return state_machine.get_state()


func get_nearest_target():
	pass


func _on_DetectionArea_body_entered(body):
	if body.has_method("apply_damage"):
		# Since this detection area will only listen to player type collisions
		add_target(body)


func _on_DetectionArea_body_exited(body):
	if target == body:
		pop_target(body)
	
