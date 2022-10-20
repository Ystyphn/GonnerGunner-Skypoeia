extends "res://parent_scripts/interactable_object.gd"

func interact(player: Node, flag: bool):
	ShopLayer.show()

func _ready():
	initialize($Sprite)
	$Area2D.connect("body_entered", self,"_on_interactable_object_entered")
	$Area2D.connect("body_exited", self,"_on_interactable_object_exited")
