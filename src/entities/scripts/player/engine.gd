extends Node2D


onready var playerRoot: KinematicBody2D = get_parent()

func change_animation(anim: String):
	playerRoot.animation.play(anim)

func flip_sprite(dir: String):
	if dir == "right":
		playerRoot.get_node("Sprite").scale.x = abs(playerRoot.get_node("Sprite").scale.x)
		playerRoot.flipped = false
	elif dir == "left":
		if playerRoot.get_node("Sprite").scale.x > 0:
			playerRoot.get_node("Sprite").scale.x = -playerRoot.get_node("Sprite").scale.x
			playerRoot.flipped = true
