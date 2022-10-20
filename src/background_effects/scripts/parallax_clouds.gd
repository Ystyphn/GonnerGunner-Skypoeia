extends ParallaxLayer

export (int) var speed

func _process(delta):
	motion_offset.x -= speed * delta
