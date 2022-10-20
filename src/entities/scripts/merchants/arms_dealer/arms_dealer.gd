extends "res://src/parents/scripts/merchant/merchant.gd"

func interact(body: Node, flag: bool):
	ShopLayer.get_node("Control").set_visible(true)
