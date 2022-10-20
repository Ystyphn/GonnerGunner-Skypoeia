extends ShipState


func enter(msg:={}) -> void:
	print(ship.name, " activated, you can now control the speed")
	ship.propulsions.activate_propulsions(true)
	ship.landed = false

func physics_update(delta) -> void:
	ship.speed += ship.acceleration * delta
	ship.speed = clamp(ship.speed, 0.0, ship.target_speed)
	
	ship.manage_tilt()
	ship.velocity.x = ship.speed * ship.get_direction()
	
	ship.move_and_slide(ship.velocity, Vector2.UP)
