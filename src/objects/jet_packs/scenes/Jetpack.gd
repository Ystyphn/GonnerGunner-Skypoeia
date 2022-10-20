extends Node2D


var boosting: bool = false
var thrust_speed: int = -190
var max_fuel: int = 250
var fuel: int = 250

onready var player: KinematicBody2D = get_parent().get_parent()
onready var recharge_delay: Timer = $recharge_delay
onready var recharge_rate: Timer = $recharge_rate

func _process(delta):
	if fuel <= 0:
		boosting = false
		if $Particles2D.emitting:
			$Particles2D.emitting = false
		if recharge_delay.is_stopped():
			recharge_delay.start()

func _physics_process(delta):
	if boosting:
		fuel -= 1
		# PlayerUi.update_boost(fuel)

func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		if !player.can_jump && fuel > 0:
			boosting = true
			if !$Particles2D.emitting:
				$Particles2D.emitting = true
			if !recharge_rate.is_stopped():
				recharge_rate.stop()
			if !recharge_delay.is_stopped():
				recharge_delay.stop()
			$AudioStreamPlayer2D.play()
	if event.is_action_released("jump"):
		if boosting:
			boosting = false
			if $Particles2D.emitting:
				$Particles2D.emitting = false
			if fuel < max_fuel:
				if recharge_delay.is_stopped():
					recharge_delay.start()
			$AudioStreamPlayer2D.stop()

func _ready():
	PlayerUi.update_boost(fuel)

func _on_recharge_delay_timeout():
	if recharge_rate.is_stopped():
		recharge_rate.start()

func _on_recharge_rate_timeout():
	if fuel < max_fuel:
		fuel += 2
		PlayerUi.update_boost(fuel)
		if recharge_rate.is_stopped():
			recharge_rate.start()

func _on_AudioStreamPlayer2D_finished():
	if boosting:
		$AudioStreamPlayer2D.play()
