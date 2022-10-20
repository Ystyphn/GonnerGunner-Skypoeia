extends RigidBody2D

func initialize(flipped: bool):
	var angle_vel: float
	var impulse_x: float
	var impulse_y: float = rand_range(-25,-55)
	set_bounce(rand_range(0.2, 0.55))
	if !flipped:
		angle_vel = rand_range(-20, -55)
		impulse_x = rand_range(-25, -45)
	else:
		angle_vel = rand_range(20, 55)
		impulse_x = rand_range(25, 45)
	set_angular_velocity(angle_vel)
	apply_impulse(Vector2(0,0), Vector2(impulse_x, impulse_y))

func _on_lifetime_timeout():
	queue_free()
