class_name Jetpack
extends Node2D


export (float) var max_fuel = 100.0
export (float) var drain_points = 0.4
export (float) var recharge_points = 0.8
export (float) var speed = 150.0
export (float) var acceleration = 1.0
export (float) var recharge_time = 2.0
export (float) var recharge_rate = 0.2

var player: CharacterClass
var current_speed: float # Determine the generated speed of this jetpack
var recharging: bool = false
var fuel: float = 100.0

onready var timer: Timer = get_node("RechargeTimer")
onready var recharge_rate_timer: Timer = get_node("RechargeRate")
onready var state_machine: StateMachine = get_node("StateMachine")


func _ready():
	yield(owner, "ready")
	player = get_parent().get_player() # Get the player from the parent
	# which is the JetpackNode
	player.jetpack_node.set_jetpack(self)
	timer.set_wait_time(recharge_time)
	recharge_rate_timer.set_wait_time(recharge_rate)


func is_fuel_full():
	return fuel == max_fuel


func set_state(new_state: String):
	state_machine.transition_to(new_state)


func _on_Timer_timeout():
	if fuel < max_fuel:
		recharge_rate_timer.start()


func _on_RechargeRate_timeout():
	fuel += recharge_points
	fuel = min(fuel, max_fuel)
	if is_fuel_full():
		recharge_rate_timer.stop()
		print("Recharge Stopped")
	print(fuel)
