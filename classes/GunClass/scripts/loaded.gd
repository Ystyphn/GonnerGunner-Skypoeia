extends GunState

func enter(msg:={}) -> void:
	# I will put something to check if there are still remaining ammo in the gun
	# later
	pass

func handle_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		gun.shooting = true
	if event.is_action_released("left_click"):
		gun.shooting = false

func physics_update(delta):
	if !gun.user.can_shoot:
		return
	gun.look_at(gun.get_global_mouse_position())
	
	if gun.shooting:
		gun.fire()
		
