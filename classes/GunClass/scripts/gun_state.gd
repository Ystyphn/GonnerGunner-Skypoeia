class_name GunState
extends State

var gun: GunClass

func _ready():
	yield(owner, "ready")
	gun = owner
