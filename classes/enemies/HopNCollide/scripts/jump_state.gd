extends HopNCollideState



func enter(msg:={}):
	if msg.has("jump_strength"):
		entity.velocity.y = msg["jump_strength"]
	else:
		entity.velocity.y = entity.jump_strength


func physics_update(delta):
	if !entity.is_on_floor():
		entity.velocity.y += Globals.gravity * delta
	if entity.velocity.y >= 0:
		state_machine.transition_to("Fall")
	
	entity.velocity.x = entity.target_velocity.x
	
	entity.move_and_slide(entity.velocity, Vector2.UP)
