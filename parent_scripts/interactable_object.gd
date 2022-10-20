extends Node


var can_be_toggled: bool = false
var mountable: bool = true
var used: bool = false

# These are the nodes shortcuts
var sprite: Sprite

func initialize(sprite_: Sprite):
	sprite = sprite_

func _on_interactable_object_entered(body: Node):
	if body.name == "Player":
		body.on_interactable = true
		if !used:
			body.interactable_obj = self
		sprite.set_frame(1)

func _on_interactable_object_exited(body: Node):
	if body.name == "Player":
		body.on_interactable = false
		if !used:
			body.interactable_obj = null
		sprite.set_frame(0)
