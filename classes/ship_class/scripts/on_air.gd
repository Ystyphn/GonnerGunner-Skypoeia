extends ShipState


func enter(msg:={}) -> void:
	ship.propulsions.activate_propulsions(false)


func physics_update(delta):
	ship.manage_tilt()
	
	if !ship.is_on_floor():
		ship.velocity.y += Globals.gravity * delta
		ship.velocity.y = clamp(ship.velocity.y, 0.0, 500.0)
	else:
		state_machine.transition_to("Landed")
	
	ship.move_and_slide(ship.velocity, Vector2.UP)
