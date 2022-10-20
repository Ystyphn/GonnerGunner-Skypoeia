extends CharacterState


func enter(msg: = {}) -> void:
	# This thing is greatly dependent on the msg paramter
	#character.animation_player.play("idle")
	if character.ship == null:
		character.velocity = Vector2.ZERO
	else:
		character.velocity.x = character.ship.velocity.x

func physics_update(delta) -> void:
	character.velocity.y = 1
	character.manage_facing()
	
	if !character.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	var x_vel = Input.get_action_strength("right") - \
			Input.get_action_strength("left")
	
	if Input.is_action_just_pressed("escape"):
		if character.interactable_object == null:
			return
		character.interactable_object.interact(character)
		state_machine.transition_to("Piloting")
		return
	
	if x_vel != 0:
		state_machine.transition_to("Walk")
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {strength=character.jump_strength})
		return
	
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		if character.on_ladder_area:
			state_machine.transition_to("Climb")
			return
	
	if character.ship != null:
		character.velocity.x += character.ship.velocity.x
	
	character.move_and_slide_with_snap(character.velocity, character.snap_vector,
			Vector2.UP)
	#character.move_and_slide(character.velocity, Vector2.UP)
