extends FlyNCollideState


func get_angle_to_target():
	if fly_n_collide.target_object != null:
		var angle = fly_n_collide.get_angle_to(fly_n_collide.target_object.global_position)
		return angle
	else:
		return null


func physics_update(delta):
	if fly_n_collide.target_object == null:
		state_machine.transition_to("Fly")
		return
	var angle: float = get_angle_to_target()
	var vel: Vector2 = Vector2(cos(angle) * fly_n_collide.top_speed,
			sin(angle) * fly_n_collide.top_speed)
	fly_n_collide.target_velocity = vel
	fly_n_collide.velocity.x = lerp(fly_n_collide.velocity.x, 
			fly_n_collide.target_velocity.x, fly_n_collide.acceleration)
	fly_n_collide.velocity.y = lerp(fly_n_collide.velocity.y, 
			fly_n_collide.target_velocity.y, fly_n_collide.acceleration)
	
	# Charge to the target
	fly_n_collide.move_and_slide(fly_n_collide.velocity, Vector2.UP)
