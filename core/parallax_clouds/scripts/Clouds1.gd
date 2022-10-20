extends ParallaxLayer

export (int) var cloud_speed = -10

func _process(delta):
	motion_offset.x += cloud_speed * delta
