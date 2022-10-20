extends CommandComputerState



func enter(msg:={}) -> void:
	pass
	

func handle_input(event: InputEvent):
	if event.is_action_pressed("reload"):
		if command_computer.ship.landing_gear_deployed:
			command_computer.ship.raise_landing_gear()
		else:
			command_computer.ship.deploy_landing_gear()
	
	if event.is_action_pressed("escape"):
		command_computer.user = false
		command_computer.set_state("Unoccupied")
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			command_computer.ship.increase_engine_output()
		elif event.button_index == BUTTON_WHEEL_DOWN:
			command_computer.ship.decrease_engine_output()
	
	if event.is_action_pressed("left"):
		if command_computer.ship.get_state() == "Active":
			command_computer.ship.face_to("left")
	elif event.is_action_pressed("right"):
		if command_computer.ship.get_state() == "Active":
			command_computer.ship.face_to("right")
	

func physics_update(delta):
	var y_vel: float = Input.get_action_strength("down") - \
			Input.get_action_strength("up")
	
	if Input.is_action_just_pressed("interact"):
		command_computer.ship.toggle_engine()
	
	if command_computer.get_ship_state() == "Active":
		command_computer.ship.velocity.y = y_vel * \
				command_computer.ship.maneuver_speed
	
