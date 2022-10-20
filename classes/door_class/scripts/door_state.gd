class_name DoorState
extends State

var door: DoorClass

func _ready():
	yield(owner, "ready")
	door = owner

