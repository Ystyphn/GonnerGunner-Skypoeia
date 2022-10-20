extends CharacterState


func enter(msg:={}) -> void:
	character.can_shoot = false

func handle_input(event: InputEvent):
	if event.is_action_pressed("escape"):
		character.set_state("Idle")

func physics_update(delta):
	character.global_position = character.command_computer.\
			position_2d.get_global_position()

func exit():
	character.command_computer = null
	character.ship = null
	character.can_shoot = true
