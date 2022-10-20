class_name CommandComputerClass
extends Node2D

var ship: ShipClass
var user
var near_users: Array
var current_instruction

onready var state_machine: StateMachine = get_node("StateMachine")
onready var position_2d: Position2D = get_node("Position2D")

func _ready():
	yield(owner, "ready")
	ship = owner
	$CollisionArea.connect("body_entered", self, "body_entered")
	$CollisionArea.connect("body_exited", self, "body_exited")
	$CollisionArea.connect("mouse_entered", self, "mouse_entered")
	$CollisionArea.connect("mouse_exited", self, "mouse_exited")

func interact(body):
	user = body
	user.command_computer = self
	user.ship = ship
	if get_state() == "Unoccupied":
		set_state("Occupied")
	elif get_state() == "Occupied":
		set_state("Unoccupied")

func set_state(new_state: String):
	$StateMachine.transition_to(new_state)

func get_ship_state():
	return ship.get_state()

func get_state():
	return $StateMachine.get_state()

func body_entered(body):
	for group in ship.get_groups():
		if body.is_in_group(group):
			near_users.append(body)
			break
			return

func body_exited(body):
	if body in near_users:
		near_users.erase(body)
		return

func mouse_entered():
	if Globals.player in near_users:
		Globals.player.interactable_object = self
		MouseManager.set_cursor_texture("HandCursor")

func mouse_exited():
	if Globals.player.interactable_object == self:
		Globals.player.interactable_object = null
	MouseManager.set_cursor_texture("NormalCursor")
