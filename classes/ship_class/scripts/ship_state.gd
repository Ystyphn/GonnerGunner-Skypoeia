class_name ShipState
extends State

var ship: ShipClass

func _ready():
	yield(owner, "ready")
	ship = owner
