extends CharacterState


func enter(msg:={}) -> void:
	#character.animation_player.play("walk")
	pass

func manage_facing():
	pass

func handle_input(event: InputEvent):
	if event.is_action_pressed("escape"):
		if character.interactable_object == null:
			return
		character.interactable_object.interact(character)
		state_machine.transition_to("Piloting")

func physics_update(delta) -> void:
	character.velocity.y = 1
	
	var x_vel = Input.get_action_strength("right") - \
			Input.get_action_strength("left")
	
	if x_vel == 0:
		state_machine.transition_to("Idle")
		character.move_and_slide_with_snap(character.velocity, character.snap_vector,
			Vector2.UP)
		return
	
	if character.do_autojump():
		var on_direction = character.is_collision_on_dir(x_vel)
		if on_direction:
			state_machine.transition_to("Jump", {strength=character.autojump_strength})
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {strength=character.jump_strength})
		return
	
	if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
		if character.on_ladder_area:
			state_machine.transition_to("Climb")
		return
	
	if !character.is_on_floor():
		state_machine.transition_to("Fall")
	
	character.manage_facing()
	
	character.velocity.x = x_vel * character.walk_speed
	
	if character.ship != null:
		character.velocity.x += character.ship.velocity.x
	
	character.move_and_slide_with_snap(character.velocity, character.snap_vector,
			Vector2.UP)
	#character.move_and_slide(character.velocity, Vector2.UP)
