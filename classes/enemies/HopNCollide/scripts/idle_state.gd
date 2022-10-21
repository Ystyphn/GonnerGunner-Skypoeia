extends HopNCollideState

func enter(msg:={}):
	entity.target_velocity.x = 0
	entity.can_hop = false
	entity.start_hop_timer()


func physics_update(delta):
	entity.velocity.y = 1
	if entity.dir != 0:
		entity.target_velocity.x = entity.walk_speed * entity.dir
		if entity.can_hop:
			state_machine.transition_to("Jump", 
					{jump_strength=entity.hop_strength})
			return
	
	if !entity.is_on_floor():
		state_machine.transition_to("Fall")
	
	if entity.velocity.x != 0:
		entity.velocity.x = lerp(entity.velocity.x, 0,
				entity.acceleration)

	entity.move_and_slide(entity.velocity, Vector2.UP)
