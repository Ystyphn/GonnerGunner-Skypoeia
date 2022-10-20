class_name FlyNCollide
extends EntityClass


export (float) var speed = 75.0
export (float) var top_speed = 100.0
export (float) var acceleration = 0.4

var target_queue: Array
var current_speed: float = 0.0
var target_velocity: Vector2
var ground_warning: bool = false
var target_object: Object
var fly_direction: int = 0

onready var state_machine: StateMachine = get_node("StateMachine")
onready var raycast: RayCast2D = get_node("RayCast2D")


func _ready():
	DebugConsole.set_debug_object(self)


func _process(delta):
	if raycast.is_colliding():
		ground_warning = true
	else:
		ground_warning = false


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_left"):
		fly_direction = -1
	elif event.is_action_pressed("ui_right"):
		fly_direction = 1


func get_direction():
	# This will return -1 or 1 for the x direction of this entity
	if velocity.x < 0:
		fly_direction = -1
		return -1
	elif velocity.x > 0:
		fly_direction = 1
		return 1
	else:
		fly_direction = 0
		return 0


func set_direction(dir: int):
	fly_direction = dir


func set_velocity(vel: Vector2):
	target_velocity = vel


func get_state():
	return state_machine.get_state()


func set_state(new_state: String):
	state_machine.transition_to(new_state)


func _on_Visibility_body_entered(body):
	if target_object == null:
		target_object = body
		set_state("Charge")
		return
	else:
		target_queue.append(body)


func _on_Visibility_body_exited(body):
	if body == target_object:
		target_object = null
		if target_queue.size() != 0:
			target_object = target_queue.pop_front()
	
	if body in target_queue:
		target_queue.erase(body)


func _on_Hitbox_body_entered(body):
	if body.has_method("apply_damage"):
		pass
	if get_state() == "Charge":
		# Change the state of this entity to regain altitude
		set_state("Fly")
