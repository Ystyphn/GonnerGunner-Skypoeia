class_name PropulsionState
extends State

var propulsion: PropulsionClass

func _ready():
	yield(owner, "ready")
	propulsion = owner
