extends Node2D

var shoot_range: int = 50 # this is the minimum distance between the player in this object 
var target: Node2D = null

onready var engine: Node2D = get_parent()
onready var round_copter: Node = engine.get_parent()

func fix_orientation():
	if target:
		if target.global_position.x > round_copter.global_position.x:
			round_copter.get_node("Sprite").scale.x = 1
		else:
			round_copter.get_node("Sprite").scale.x = -1

func get_nearest_point(points: PoolVector2Array):
	var nearest_point: Vector2 = points[0]
	for p in points:
		if (round_copter.get_global_position() - p).length() <= shoot_range:
			return p
		elif p < nearest_point:
			nearest_point = p
	return nearest_point

func target_player():
	var space_state: Physics2DDirectSpaceState = get_world_2d().direct_space_state
	var player_extents: PoolVector2Array = round_copter.get_parent().player.get_extents()
	for p in player_extents:
		var result = space_state.intersect_ray(round_copter.get_global_position(), p, [round_copter,self,get_parent()])
		if result.size() >0:
			if result["collider"].name == "Player":
				target = result["collider"]

func _physics_process(delta):
	if round_copter.get_parent().player:
		target_player()
	else:
		if target != round_copter.get_parent().ship:
			target = round_copter.get_parent().ship
	if target:
		if target.name == "Player":
			if (target.global_position - round_copter.global_position).length() > shoot_range:
				# radians and degrees actually means the angle... NOTHING ELSE
				var radians: float = round_copter.get_angle_to(target.global_position)
				round_copter.velocity.x = cos(radians) * round_copter.speed
				round_copter.velocity.y = sin(radians) * round_copter.speed
			else:
				round_copter.velocity = Vector2.ZERO
				if round_copter.can_shoot:
					round_copter.shoot()
		elif target == round_copter.get_parent().ship:
			var target_position = get_nearest_point(round_copter.get_parent().ship.get_extents())
			if (round_copter.get_global_position() - target_position).length() <= shoot_range:
				round_copter.velocity = Vector2.ZERO
				if round_copter.can_shoot:
					round_copter.shoot(target_position)
			elif(round_copter.get_global_position() - target_position).length() > shoot_range:
				var radians: float = round_copter.get_angle_to(target.global_position)
				round_copter.velocity.x = cos(radians) * round_copter.speed
				round_copter.velocity.y = sin(radians) * round_copter.speed
	if engine.critical_height && target.global_position.y > round_copter.global_position.y:
		round_copter.velocity.y = 0
	fix_orientation()
