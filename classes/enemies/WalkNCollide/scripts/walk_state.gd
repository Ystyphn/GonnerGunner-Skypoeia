extends WalkNCollideState


func physics_update(delta):
	entity.target_velocity.x = entity.dir * entity.walk_speed
	entity.velocity.x = lerp(entity.velocity.x, 
			entity.target_velocity.x, entity.acceleration)
	
	if entity.do_autojump():
		if entity.tile_detectors.is_collision_on_dir(entity.dir):
			state_machine.transition_to("Jump", {jump_strength=entity.autojump_strength})
	
	if !entity.is_on_floor():
		state_machine.transition_to("Fall")
	
	if entity.velocity.x == 0 and entity.target_velocity.x == 0:
		# Making this jerk stop
		state_machine.transition_to("Idle")
	
	entity.move_and_slide_with_snap(entity.velocity, entity.snap_vector,
			Vector2.UP)
