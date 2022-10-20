extends Node2D

var opened: bool = false
var on_player_reach: bool = false

func apply_damage(damage):
	return

func interact(player: Node, flag: bool):
	if !opened:
		opened = true
		$StaticBody2D.set_collision_layer_bit(0, false)
	else:
		opened = false
		$StaticBody2D.set_collision_layer_bit(0, true)
	print("Door toggled")

func _process(delta):
	if opened:
		if on_player_reach:
			$Sprite.set_frame(3)
		else:
			$Sprite.set_frame(2)
	else:
		if on_player_reach:
			$Sprite.set_frame(1)
		else:
			$Sprite.set_frame(0)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.on_interactable = true
		if !body.interactable_obj:
			body.interactable_obj = self
		on_player_reach = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body.on_interactable = false
		if body.interactable_obj == self:
			body.interactable_obj = null
		on_player_reach = false
