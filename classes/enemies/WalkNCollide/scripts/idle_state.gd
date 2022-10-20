extends WalkNCollideState


func physics_update(delta):
	entity.target_velocity.x = entity.dir * entity.walk_speed
	
	if !entity.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	if entity.target_velocity != Vector2.ZERO:
		state_machine.transition_to("Walk")
		return
