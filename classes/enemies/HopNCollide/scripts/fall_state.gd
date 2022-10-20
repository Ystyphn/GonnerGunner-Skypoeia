extends HopNCollideState


func physics_update(delta):
	if entity.velocity.y <= 225:
		entity.velocity.y += Globals.gravity * delta
	else:
		entity.velocity.y = 225
	
	entity.velocity.x = lerp(entity.velocity.x, entity.target_velocity,
			entity.acceleration)
	
	entity.move_and_slide(entity.velocity, Vector2.UP)
