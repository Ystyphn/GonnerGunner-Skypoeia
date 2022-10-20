extends FlyNCollideState



func enter(msg: = {}):
	fly_n_collide.target_velocity = Vector2.ZERO


func physics_update(delta):
	if !fly_n_collide.is_on_floor():
		pass
	pass
