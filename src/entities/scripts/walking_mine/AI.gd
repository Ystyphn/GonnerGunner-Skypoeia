extends Node2D


var current_state: int
var player_seen: bool = false
var target: Node = null

onready var engine: Node = get_parent()
onready var walking_mine: Node = get_parent().get_parent()

func fix_orientation(dir: int):
	if dir < 0:
		walking_mine.get_node("Sprite").flip_h = true
	else:
		walking_mine.get_node("Sprite").flip_h = false
		
func target_player():
	var space_state: Physics2DDirectSpaceState = get_world_2d().direct_space_state
	var player_extents: PoolVector2Array = walking_mine.get_parent().player.get_extents()
	for p in player_extents:
		var result = space_state.intersect_ray(walking_mine.get_global_position(), p, [walking_mine,self,get_parent()])
		if result.collider.name == "Player":
			target = result.collider
			player_seen = true
			if walking_mine.current_state != walking_mine.APPROACHING:
				walking_mine.current_state = walking_mine.APPROACHING
			if !engine.get_node("patience").is_stopped():
				engine.get_node("patience").stop()
			return
		else:
			player_seen = false
			walking_mine.current_state = walking_mine.WAITING

func _physics_process(delta):
	if walking_mine.active:
		if !player_seen && walking_mine.get_parent().player:
			target_player()
		if walking_mine.current_state != walking_mine.ARMED:
			if player_seen: 
				if target.global_position.x > walking_mine.global_position.x:
					# going right
					walking_mine.velocity.x = walking_mine.speed
				else:
					walking_mine.velocity.x = -walking_mine.speed
				walking_mine.animation.play("walk")
			else:
				walking_mine.get_node("Sprite").set_frame(8)
				if engine.get_node("patience").is_stopped():
					engine.get_node("patience").start()
		else:
			walking_mine.velocity.x = 0
			walking_mine.get_node("Sprite").set_frame(8)

func _on_patience_timeout():
	walking_mine.current_state = walking_mine.ARMED
