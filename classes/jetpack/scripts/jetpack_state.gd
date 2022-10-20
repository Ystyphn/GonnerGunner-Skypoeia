class_name JetpackState
extends State


var jetpack: Jetpack

func _ready():
	yield(owner, "ready")
	jetpack = owner
