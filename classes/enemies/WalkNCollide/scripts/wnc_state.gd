class_name WalkNCollideState
extends State


var entity: WalkNCollide

func _ready():
	yield(owner, "ready")
	entity = owner
