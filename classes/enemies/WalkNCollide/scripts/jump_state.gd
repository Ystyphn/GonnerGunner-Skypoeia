extends WalkNCollideState


func enter(msg:={}):
	if msg.has("jump_strength"):
		entity.velocity.y = msg["jump_strength"]
	else:
		entity.velocity.y = entity.jump_strength
	

func physics_update(delta):
	entity.target_velocity.x = entity.dir * entity.walk_speed
	if entity.velocity.y < 0:
		entity.velocity.y += Globals.gravity * delta
	else:
		state_machine.transition_to("Fall")

	entity.target_velocity.x = entity.dir * entity.on_air_speed
	
	if entity.velocity != entity.target_velocity:
		entity.velocity.x = lerp(entity.velocity.x, entity.target_velocity.x,
				entity.acceleration)
	
	entity.move_and_slide(entity.velocity, Vector2.UP)
