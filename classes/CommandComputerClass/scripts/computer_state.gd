class_name CommandComputerState
extends State

var command_computer: CommandComputerClass

func _ready():
	yield(owner, "ready")
	command_computer = owner
