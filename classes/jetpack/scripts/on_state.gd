extends JetpackState


var player: Player


func enter(msg:={}):
	if jetpack.fuel == 0:
		player.set_state("Fall")
		state_machine.transition_to("Off")
	player = jetpack.player


func physics_update(delta):
	if Input.is_action_pressed("jump"):
		jetpack.current_speed -= jetpack.acceleration
		player.velocity.y = max(jetpack.current_speed, jetpack.speed)
		jetpack.current_speed = player.velocity.y
	else:
		player.set_state("Fall")
		state_machine.transition_to("Off")


func exit():
	player = null
