extends Sprite

var can_repair: bool = false # This will be the  variable if the ship is repairable
var playerObject: Node
var repairing: bool = false
var repairPoints: int

onready var hullBar: TextureProgress = $InteractableMonitor/NinePatchRect/TextureProgress
onready var monitor: NinePatchRect = $InteractableMonitor/NinePatchRect
onready var ship: Node2D = get_parent().get_parent()


func interact(body: Node, flag: bool):
	if !monitor.visible:
		monitor.visible = true
	playerObject = body
	self.repairPoints = playerObject.repairPoints
	playerObject.repairSpeed.connect("timeout", ship, "add_health", [repairPoints])

func initialize_hull(value_: int, max_value_: int):
	hullBar.max_value = max_value_
	hullBar.value = value_

func update_hull(value_: int):
	hullBar.value = value_

func refresh():
	repairPoints = 0
	playerObject.repairSpeed.disconnect("timeout", ship, "add_health")
	if !playerObject.repairSpeed.is_stopped():
		playerObject.repairSpeed.stop()
	playerObject = null

func _process(delta):
	if hullBar.value < hullBar.max_value:
		if !can_repair:
			can_repair = true
	else:
		can_repair = false
		repairing = false

func _physics_process(delta):
	if repairing:
		if ship.health >= ship.max_health:
			ship.health = ship.max_health
			repairing = false
			can_repair = false
			if !playerObject.repairSpeed.is_stopped():
				playerObject.repairSpeed.stop()

func _ready():
	#monitor.set_visible(false)
	hullBar.max_value = ship.max_health
	hullBar.value = ship.health

func _on_computer_body_entered(body):
	if body.name == "Player":
		body.on_interactable = true
		body.interactable_obj = self
		set_frame(1)
	
func _on_computer_body_exited(body):
	if body.name == "Player":
		body.on_interactable = false
		body.interactable_obj = null
		if monitor.visible:
			monitor.set_visible(false)
			refresh()
		set_frame(0)

func _on_TextureButton_pressed():
	if can_repair:
		if playerObject.repairSpeed.is_stopped():
			playerObject.repairSpeed.start()
			repairing = true
