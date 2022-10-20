"""
Upon entering the climb state, the Current weapon should be hidden but still
working
"""
extends CharacterState


func enter(msg:={})-> void:
	character.set_collision_mask_bit(10, false)
	character.current_weapon.set_visible(false)
	#character.set_animation("climb")
	character.velocity.x = 0

func physics_update(delta) -> void:
	var climb_direction: int = Input.get_action_strength("down") -\
			Input.get_action_strength("up")
	
	if Input.is_action_just_pressed("left") or \
			Input.is_action_just_pressed("right"):
		state_machine.transition_to("Idle")
	
	character.global_position.x = character.ladder.global_position.x
	
	if climb_direction == 0:
		character.stop_animation(false)
	else:
		character.set_animation("climb")
	
	character.velocity.y = climb_direction
	
	character.velocity *= character.climb_speed
	
	character.move_and_slide(character.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
		return
	
	if character.is_on_floor():
		state_machine.transition_to("Idle")
		return
	
	if !character.on_ladder_area:
		state_machine.transition_to("Idle")
		return

func exit():
	character.set_collision_mask_bit(10, true)
	character.current_weapon.set_visible(true)
