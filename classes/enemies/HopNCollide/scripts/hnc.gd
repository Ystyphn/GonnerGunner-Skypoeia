class_name HopNCollide
extends EntityClass


export (float) var hop_strength = 210
export (float, 0.01, 1.0) var acceleration = 0.9

var dir: int
var target_velocity: Vector2
var target: Object
var target_queue: Array
var can_hop: bool = true

onready var tile_detectors: Node2D = get_node("TileDetectors")
onready var hop_timer: Timer = get_node("HopTimer")


func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		dir = -1
	elif event.is_action_pressed("ui_right"):
		dir = 1
	elif event.is_action_pressed("ui_down"):
		dir = 0


func _process(delta):
	pass


func stop_hop_timer():
	if !hop_timer.is_stopped():
		hop_timer.stop()


func start_hop_timer():
	if hop_timer.is_stopped():
		hop_timer.start()


func add_target(body):
	if body in target_queue:
		return
	if target == null:
		target = body
	else:
		if not body in target_queue:
			target_queue.append(body)


func get_state() -> String:
	return state_machine.get_state()


func set_state(new_state: String):
	state_machine.transition_to(new_state)


func pop_target(body):
	if target != null:
		if target == body:
			target = null
			if target_queue.size() > 0:
				target = target_queue.pop_front()
	if body in target_queue:
		target_queue.erase(body)
		return


func _on_DetectionArea_body_entered(body):
	if body.has_method("apply_damage"):
		add_target(body)


func _on_DetectionArea_body_exited(body):
	if body.has_method("apply_damage"):
		pop_target(body)


func _on_HopTimer_timeout():
	can_hop = true
