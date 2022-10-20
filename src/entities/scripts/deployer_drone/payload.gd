extends Node2D

var current_payload: Node = null
var payload_type: String

onready var AI: Node = get_parent().get_node("engine/AI")
onready var DepDrone: Node = get_parent()

func carry(payload: Node):
	# This should be the one to activate the drone
	payload_type = payload.PAYLOAD_TYPE
	if payload_type == "DROP_BOT":
		payload.set_position($Position2D.position)
		get_parent().get_node("Sprite/AnimationPlayer").play("fly_carry")
		current_payload = payload
		current_payload.carried()
		add_child(payload)
	elif payload_type == "MISSILE":
		payload.set_position($Position2D.position)
		get_parent().get_node("Sprite/AnimationPlayer").play("fly_carry")
		current_payload = payload
		current_payload.carried()
		current_payload.target = get_parent().get_node("engine/AI").target
		add_child(payload)
		get_parent().get_node("sfx").set_stream(get_parent().missile_launch)

func _process(delta):
	if DepDrone.current_state != DepDrone.RETREAT && current_payload:
		current_payload.target = get_parent().get_node("engine/AI").target

func refresh():
	current_payload = null
	payload_type = " "
	get_parent().current_state = get_parent().RETREAT
	get_parent().get_node("Sprite/AnimationPlayer").play("fly_free")

func release():
	if payload_type == "DROP_BOT" || "MISSILE":
		if payload_type == "MISSILE":
			current_payload.set_target(get_parent().get_node("engine/AI").target)
			get_parent().get_node("sfx").play()
		current_payload.dropped($Position2D.global_position)
		remove_child(current_payload)
		get_parent().get_parent().add_child(current_payload)
		current_payload = null
		get_parent().get_node("Sprite/AnimationPlayer").play("fly_free")
		get_parent().current_state = get_parent().RETREAT
