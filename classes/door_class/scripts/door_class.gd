class_name DoorClass
extends StaticBody2D

export (int) var health = 600
export (int) var damage_reduction = 0.5

export (NodePath) var mouse_collider_path
export (NodePath) var sprite_path

var colliding_bodies: Array
var owner_group: String = "player_group" # This will change, this is to indicate 
# Who is the owner of this ship

onready var mouse_collider = get_node(mouse_collider_path)
onready var sprite: Sprite = get_node(sprite_path)

func _ready():
	$Collider.connect("body_entered", self, "body_entered")
	$Collider.connect("body_exited", self, "body_exited")

func apply_damage(damage: Dictionary = {}):
	pass

func toggle():
	if get_state() == "Close":
		set_state("Open")
	elif get_state() == "Open":
		set_state("Close")

func set_state(new_state: String):
	$StateMachine.transition_to(new_state)

func get_state():
	return $StateMachine.get_state()

func body_entered(body):
	print("Area entered")
	if body.is_in_group(owner_group):
		set_state("Open")
		
	
func body_exited(body):
	print("Area exited with ", body.name)
	if body.is_in_group(owner_group):
		set_state("Close")
