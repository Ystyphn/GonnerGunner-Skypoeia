extends WalkNCollideState


func physics_update(delta):
	entity.target_velocity.x = entity.dir * entity.walk_speed
	if entity.velocity.y <= 225:
		entity.velocity.y += Globals.gravity * delta
	else:
		entity.velocity.y = 225
	
	if entity.is_on_floor():
		state_machine.transition_to("Idle")
		return
	
	if entity.velocity != entity.target_velocity:
		entity.velocity.x = lerp(entity.velocity.x, entity.target_velocity.x,
				entity.acceleration)
	
	entity.move_and_slide(entity.velocity, Vector2.UP)
