extends NinePatchRect

var player_object: KinematicBody2D

func initialize(username: String, script_to_connect: Object = null, methods: Array = []):
	# Script to connect tells where to connect the button signal
	$HBoxContainer/Username.set_text(username)
	if script_to_connect:
		if script_to_connect:
			$HBoxContainer/MarginContainer/HBoxContainer/Delete.connect("pressed",
					script_to_connect, methods[0], [username])
			$HBoxContainer/MarginContainer/HBoxContainer/Play.connect("pressed",
					script_to_connect, methods[1], [ResLoader.get_player_data(username)])
		else:
			print("No methods specified")
	else:
		print("No object to connect, buttons won't execute actions")
