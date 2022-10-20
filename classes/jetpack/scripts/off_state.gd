extends JetpackState

var player: Player


func enter(msg:={}):
	jetpack.current_speed = 0.0
	if player == null:
		return
	player = jetpack.player
	player.set_state("Fall")
	if !jetpack.is_fuel_full():
		jetpack.timer.start()


func physics_update(delta):
	pass


func exit():
	player = null
