extends Node2D

const MISSILE_RANGE: int = 200

var aggressive: bool = false
var dir_radians = null
var target: Node = null
var target_on_range: bool = false

onready var engine: Node = get_parent()
onready var payload: Node = engine.get_parent().get_node("payload")
onready var DepDrone: Node = engine.get_parent()

func initialize(pos: Vector2, _aggressive: bool = false):
	DepDrone.set_global_position(pos)
	aggressive = _aggressive

func is_target_on_range(target_: Node) -> bool:
	if (DepDrone.position - target_.position).length() <= MISSILE_RANGE:
		return true
	else:
		return false

func on_target_extents(target_: Node):
	# this only works on target_ with get_extents function
	for p in target_.get_extents():
		if (DepDrone.position - p).length() <= MISSILE_RANGE:
			return true
	return false

func raycast_to(target_: Node, expected_name: String):
	var space_state := get_world_2d().direct_space_state
	var result = space_state.intersect_ray(DepDrone.position, target.position, [DepDrone])
	if result.collider.name == expected_name:
		pass

func _physics_process(delta):
	if DepDrone.get_parent().player:
		target = DepDrone.get_parent().player
	else:
		target = DepDrone.get_parent().ship
	if payload.payload_type == "DROP_BOT":
		# This will execute if the payload is droppable
		if DepDrone.current_state == DepDrone.APPROACH:
			if !engine.critical_height || target.global_position.y < global_position.y:
				var radians: float = DepDrone.get_angle_to(target.global_position)
				# Go near to the target if there are no ground detection only happen if the payload is a robot
				DepDrone.velocity.x = cos(radians) * DepDrone.speed
				DepDrone.velocity.y = sin(radians) * DepDrone.speed
			elif engine.critical_height && target.global_position.y > global_position.y:
				DepDrone.velocity.y = 0
				# This is the dropping logic
				if round(target.global_position.x) > round(DepDrone.global_position.x):
					DepDrone.velocity.x = DepDrone.speed
				if round(target.global_position.x) < round(DepDrone.global_position.x):
					DepDrone.velocity.x = -DepDrone.speed
				if abs(round(DepDrone.global_position.x) - round(target.global_position.x)) <= 5:
					DepDrone.velocity.x = 0
					if DepDrone.payload_node.current_payload:
						DepDrone.payload_node.release()
		else:
			# If the drone no longer has payload
			if !dir_radians:
				var dir_degrees: float = rand_range(135, 225)
				dir_radians = deg2rad(dir_degrees)
			DepDrone.velocity.x = cos(dir_radians) * DepDrone.speed
			DepDrone.velocity.y = sin(dir_radians) * DepDrone.speed
	elif payload.payload_type == "MISSILE":
		# This will happen if the payload is launchable
		if DepDrone.current_state  == DepDrone.APPROACH:
			# Only move nearer to the target if the target isn't on range yet
			if !target_on_range:
				var radians: float = get_angle_to(target.position)
				DepDrone.velocity.x = cos(radians) * DepDrone.speed
				DepDrone.velocity.y = sin(radians) * DepDrone.speed
				target_on_range = is_target_on_range(target)
			else:
				if payload.current_payload:
					payload.release()
		else:
			if !dir_radians:
				var dir_degrees: float = rand_range(135, 225)
				dir_radians = deg2rad(dir_degrees)
			DepDrone.velocity.x = cos(dir_radians) * DepDrone.speed
			DepDrone.velocity.y = sin(dir_radians) * DepDrone.speed
	else:
			# If the drone no longer has payload
			if !dir_radians:
				var dir_degrees: float = rand_range(135, 225)
				dir_radians = deg2rad(dir_degrees)
			DepDrone.velocity.x = cos(dir_radians) * DepDrone.speed
			DepDrone.velocity.y = sin(dir_radians) * DepDrone.speed
