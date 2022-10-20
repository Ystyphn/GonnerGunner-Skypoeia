extends CharacterState



func physics_update(delta):
	# This is necessary since the character can still receive damages unless
	# its dead
	character.move_and_slide_with_snap(Vector2(0,0), character.snap_vector, 
			Vector2.UP)



