class_name FlyNCollideState
extends State


var fly_n_collide: FlyNCollide


func _ready():
	yield(owner, "ready")
	fly_n_collide = owner
