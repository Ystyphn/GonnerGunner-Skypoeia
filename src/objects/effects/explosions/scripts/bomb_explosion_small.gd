extends Area2D


var damage: int

func initialize(dmg: int, pos: Vector2, layer: int):
	damage = dmg
	set_global_position(pos)
	set_collision_layer(layer)

func _ready():
	$Sprite/AnimationPlayer.play("default")

func _on_bomb_explosion_small_body_entered(body):
	if body.name != "TileMap":
		var space_state := get_world_2d().direct_space_state
		if body.name == "Player":
			var result := space_state.intersect_ray(global_position, 
				body.global_position, [self])
			if result.size() > 0:
				if result["collider"].name == body.name:
					body.apply_damage(damage)
		elif body.name == "trapdoor_1":
			pass
		else:
			body.apply_damage(damage)
	set_monitoring(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
