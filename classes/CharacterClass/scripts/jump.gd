extends CharacterState


func enter(msg:={}):
	var strength = msg["strength"]
	character.velocity.y = strength


func physics_update(delta) -> void:
	var x_vel = Input.get_action_strength("right") -\
			Input.get_action_strength("left")
	
	character.velocity.y += Globals.gravity * delta
	character.velocity.x = x_vel * character.air_speed
	character.manage_facing()
	
	if character.ship != null:
		character.velocity.x += character.ship.velocity.x
	
	character.move_and_slide(character.velocity,
			Vector2.UP)
	
	if character.is_on_ceiling():
		character.velocity.y = 0
		return
	
	if character.velocity.y >= 0:
		state_machine.transition_to("Fall")
		return
	
	if character.is_on_floor():
		state_machine.transition_to("Idle")
		return
	
	
	
