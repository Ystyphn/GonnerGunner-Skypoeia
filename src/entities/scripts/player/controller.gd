extends Node2D

var moving_left: bool = false
var moving_right: bool = false
var climb_up: bool = false
var climb_down: bool = false
var jump: bool = false

onready var parent: Node = get_parent()
onready var player: Node = get_parent().get_parent()

func reset_move_switches():
	print("move switches reset")
	moving_left = false
	moving_right = false
	climb_down = false
	climb_up = false

func _physics_process(delta):
	if player.current_state == player.FREE:
		if jump:
			player.jump = true
			player.jump()
		else:
			parent.playerRoot.jump = false
		if moving_left:
			#moving_right = false
			parent.playerRoot.velocity.x = -parent.playerRoot.speed
			parent.change_animation("run" if parent.playerRoot.is_on_floor() else "jump")
		elif moving_right:
			#moving_left = false
			parent.playerRoot.velocity.x = parent.playerRoot.speed
			parent.change_animation("run" if parent.playerRoot.is_on_floor() else "jump")
		else:
			parent.change_animation("idle" if parent.playerRoot.is_on_floor() else "jump")
			parent.playerRoot.velocity.x = 0
	if player.current_state == player.CLIMBING:
		player.can_jump = true
		if jump:
			player.jump = true
			player.jump()
		if moving_right:
			moving_left = false
			player.velocity.x = player.climb_speed
			if player.animation.get_current_animation() != "climbing":
				player.animation.play("climbing")
			else:
				player.animation.play()
		if moving_left:
			moving_right = false
			player.velocity.x = -player.climb_speed
			if player.animation.get_current_animation() != "climbing":
				player.animation.play("climbing")
			else:
				player.animation.play()
		if !moving_left && !moving_right:
			player.velocity.x = 0
		if climb_up:
			player.velocity.y = -player.climb_speed
		elif climb_down:
			player.velocity.y = player.climb_speed
		elif !climb_up && !climb_down:
			player.velocity.y = 0
	if player.current_state == player.GRAPPLED:
		if jump:
			player.jump = true
			player.jump()
			player.can_jump = false
			player.colliding = false
			player.current_state = player.FREE
			player.grappling_hook.release()
		
func _unhandled_input(event) -> void:
	if player.current_state != player.MOUNTING:
		if event.is_action_pressed("interact") && player.on_interactable:
			player.interactable_obj.interact(player, true)
		# MOVING LEFT AND RIGHT PRESSED
		jump = event.is_action_pressed("jump") and (parent.playerRoot.is_on_floor() || 
			player.current_state == player.CLIMBING || player.current_state == player.GRAPPLED)
		if event.is_action_pressed("left") && !event.is_action_pressed("right"):
			moving_left = true
		if event.is_action_pressed("right") && !event.is_action_pressed("left"):
			moving_right = true
		#CLIMBING UP PRESSED
		if event.is_action_pressed("up") && !event.is_action_pressed("down") && player.can_climb:
			climb_up = true
			climb_down = false
			if player.animation.get_current_animation() != "climbing":
				player.animation.play("climbing")
			else:
				player.animation.play()
			if player.current_state != player.CLIMBING:
				player.current_state = player.CLIMBING
		#CLIMBING DOWN PRESSED
		if event.is_action_pressed("down") && !event.is_action_pressed("up") && player.can_climb:
			climb_down = true
			climb_up = false
			if player.animation.get_current_animation() != "climbing":
				player.animation.play("climbing")
			else:
				player.animation.play()
			if player.current_state != player.CLIMBING:
				player.current_state = player.CLIMBING
		#CLIMBING UP RELEASED
		if event.is_action_released("up") && player.current_state == player.CLIMBING:
			climb_up = false
			if player.animation.get_current_animation() == "climbing":
				player.animation.stop(false)
		#CLIMBING DOWN RELEASED
		if event.is_action_released("down") && player.current_state == player.CLIMBING:
			climb_down = false
			if player.animation.get_current_animation() == "climbing":
				player.animation.stop(false)
		# MOVING LEFT AND RIGHT RELEASED
		if event.is_action_released("left"):
			moving_left = false
			if player.animation.get_current_animation() == "climbing":
				player.animation.stop(false)
		if event.is_action_released("right"):
			moving_right = false
			if player.animation.get_current_animation() == "climbing":
				player.animation.stop(false)
	else:
		if event.is_action_pressed("interact"):
			player.get_parent().used(false) # allowing you to control the ship
			player.interactable_obj.interact(player, false)
			player.current_state = player.FREE
