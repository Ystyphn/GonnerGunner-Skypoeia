extends Area2D

var mountable: bool = false

onready var trapdoor: Node = $trapdoor_1
onready var sprite: Sprite = $trapdoor_1/Sprite

func apply_damage(dmg: int):
	print("A projectile should be blocked")

func interact(body: Node, none: bool = false):
	if trapdoor.rotation_degrees == 0:
		trapdoor.set_rotation_degrees(270)
	elif trapdoor.rotation_degrees == 270:
		trapdoor.set_rotation_degrees(0)
	Globals.play_audio(global_position, Globals.TRAPDOOR_SOUND)

func _on_trapdoor_1_body_entered(body):
	if body.name == "Player":
		body.on_interactable = true
		body.interactable_obj = self
		sprite.set_frame(1)

func _on_trapdoor_1_body_exited(body):
	if body.name == "Player":
		body.on_interactable = false
		body.interactable_obj = null
		sprite.set_frame(0)

func _ready():
	#trapdoor.set_rotation_degrees(270)
	pass
