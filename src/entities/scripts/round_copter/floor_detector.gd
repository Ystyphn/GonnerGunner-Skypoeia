extends RayCast2D

func _physics_process(delta):
	if is_colliding():
		get_parent().critical_height = true
	else:
		get_parent().critical_height = false
