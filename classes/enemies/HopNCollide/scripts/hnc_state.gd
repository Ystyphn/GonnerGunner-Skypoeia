class_name HopNCollideState
extends State


var entity: HopNCollide


func _ready():
	yield(owner, "ready")
	entity = owner
