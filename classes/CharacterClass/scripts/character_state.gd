class_name CharacterState
extends State

var character: CharacterClass

func _ready():
	yield(owner, "ready")
	character = owner
