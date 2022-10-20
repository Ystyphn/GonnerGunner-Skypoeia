extends Node2D

var broken: bool = false
var can_repair: bool = true
var playerObject: Node
var repairing: bool = false
var repairPoints: int

onready var ke_turret: Node = $KE_Turret_T1
onready var monitor: NinePatchRect = $InteractableMonitor/NinePatchRect
onready var hpBar: TextureProgress = $InteractableMonitor/NinePatchRect/TextureProgress

func interact(body: Node, flag: bool):
	if !monitor.visible:
		monitor.visible = true
	playerObject = body
	self.repairPoints = playerObject.repairPoints
	playerObject.repairSpeed.connect("timeout", ke_turret, "add_health", [repairPoints])

func refresh():
	repairPoints = 0
	playerObject.repairSpeed.disconnect("timeout", ke_turret, "add_health")
	if !playerObject.repairSpeed.is_stopped():
		playerObject.repairSpeed.stop()
	playerObject = null

func update_health(val: int):
	hpBar.value = val

func _process(delta):
	if hpBar.value < hpBar.max_value:
		if !can_repair:
			can_repair = true
	else:
		can_repair = false
		repairing = false

func _physics_process(delta):
	if repairing:
		if ke_turret.health >= ke_turret.max_health:
			ke_turret.health = ke_turret.max_health
			repairing = false
			can_repair = false
			if !playerObject.repairSpeed.is_stopped():
				playerObject.repairSpeed.stop()

func _ready():
	hpBar.max_value = ke_turret.max_health
	hpBar.value = ke_turret.health

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.on_interactable = true
		body.interactable_obj = self
		if broken:
			ke_turret.update_animation(3)
		else:
			ke_turret.update_animation(1)

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body.on_interactable = false
		body.interactable_obj = null
		if monitor.visible:
			monitor.set_visible(false)
			refresh()
		if broken:
			ke_turret.update_animation(2)
		else:
			ke_turret.update_animation(0)

func _on_TextureButton_pressed():
	if can_repair:
		if playerObject.repairSpeed.is_stopped():
			playerObject.repairSpeed.start()
			playerObject.staminaRecov.stop()
			repairing = true
