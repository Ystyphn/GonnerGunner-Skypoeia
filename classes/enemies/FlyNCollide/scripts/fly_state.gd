extends FlyNCollideState


func enter(msg: = {}):
	if fly_n_collide.get_direction() == 0:
		fly_n_collide.set_direction(round(rand_range(-1, 1)))


func physics_update(delta):
	# Gain altitude if the ground warning is true
	if fly_n_collide.ground_warning:
		fly_n_collide.target_velocity.y = -fly_n_collide.speed
		fly_n_collide.target_velocity.x = fly_n_collide.speed * fly_n_collide.fly_direction
	else:
		fly_n_collide.target_velocity.y = 0
		fly_n_collide.target_velocity.x = fly_n_collide.speed * fly_n_collide.fly_direction
	
	if fly_n_collide.target_object != null and !fly_n_collide.ground_warning:
		state_machine.transition_to("Charge")
	
	# Accelerate to acheive the target velocity
	fly_n_collide.velocity.x = lerp(fly_n_collide.velocity.x, 
			fly_n_collide.target_velocity.x, fly_n_collide.acceleration)
	fly_n_collide.velocity.y = lerp(fly_n_collide.velocity.y, 
			fly_n_collide.target_velocity.y, fly_n_collide.acceleration)
	
	fly_n_collide.move_and_slide(fly_n_collide.velocity, Vector2.UP)
