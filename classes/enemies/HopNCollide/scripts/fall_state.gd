extends HopNCollideState


func physics_update(delta):
	if entity.velocity.y <= 225:
		entity.velocity.y += Globals.gravity * delta
	else:
		entity.velocity.y = 225
	
	entity.velocity.x = lerp(entity.velocity.x, entity.target_velocity.x,
			entity.acceleration)
	
	if entity.is_on_floor():
		state_machine.transition_to("Idle")
		return
	
	entity.move_and_slide(entity.velocity, Vector2.UP)
