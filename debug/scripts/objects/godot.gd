extends KinematicBody2D

enum {
	REST,
	CARRIED
	DROPPING
}

var current_state: int
var velocity: Vector2

func carried():
	current_state = CARRIED

func dropped(pos: Vector2):
	# This is the function that will be called if it was dropped
	set_collision_mask(1)
	position = pos
	current_state = DROPPING

func _physics_process(delta):
	if current_state == CARRIED:
		velocity = Vector2.ZERO
	elif current_state == DROPPING:
		velocity.y += Globals.gravity * delta
	elif current_state == REST:
		velocity.y = 1
	if is_on_floor():
		current_state = REST
	velocity = move_and_slide(velocity, Vector2.UP, true)
