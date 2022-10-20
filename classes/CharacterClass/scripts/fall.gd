extends CharacterState


func enter(msg:={}) -> void:
	#character.animation_player.play("fall")
	if msg.has("fall_offset"):
		character.velocity.y = msg["fall_offset"]
	
func physics_update(delta) -> void:
	if character.velocity.y < 125:
		character.velocity.y += Globals.gravity * delta
	
	var x_vel = Input.get_action_strength("right") -\
			Input.get_action_strength("left")
	
	character.velocity.x = x_vel * character.air_speed
	character.manage_facing()
	
	character.move_and_slide(character.velocity,
			Vector2.UP)
	
	if character.is_on_floor():
		if x_vel == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
		return
	
	character.move_and_slide(character.velocity, Vector2.UP)
