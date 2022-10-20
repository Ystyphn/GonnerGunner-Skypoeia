extends ShipState


func enter(msg:={}) -> void:
	ship.propulsions.activate_propulsions(false)

func reset_tilt():
	ship.rotation_degrees = lerp(ship.rotation_degrees, 0.0, ship.tilt_speed)

func physics_update(delta):
	if ship.velocity.x != 0:
		ship.velocity.x = lerp(ship.velocity.x, 0.0, ship.friction)
		ship.move_and_slide(ship.velocity, Vector2.UP)
		reset_tilt()

	if !ship.is_on_floor():
		ship.velocity.y += Globals.gravity * delta
		if ship.rotation_degrees != 0:
			reset_tilt()
	else:
		ship.velocity.y = 1
		if ship.rotation_degrees != 0:
			reset_tilt()
	
	ship.move_and_slide(ship.velocity, Vector2.UP)
