extends GunClass

var parameter_data: Dictionary
var user # This should be an entity class or a player class

func _ready():
	yield(owner, "ready")
	user = owner
	remaining_ammo = max_ammo
	set_firerate(firerate)
	set_reload_time(reload_time)
	parameter_data["damage"] = damage
	parameter_data["pierce"] = pierce
	parameter_data["crit_chance"] = crit_chance
	parameter_data["max_range"] = max_range
	parameter_data["speed"] = bullet_speed
	parameter_data["crit_multiplier"] = crit_multiplier

func fire():
	if !can_shoot:
		return
	bullet_spawn_point.add_child(gunfire_scene.instance())
	parameter_data["angle"] = get_global_rotation()
	parameter_data["pos"] = bullet_spawn_point.get_global_position()
	var bullet = bullet_scene.instance()
	bullet.initialize(parameter_data)
	Globals.game_scene.projectiles_node.add_child(bullet)
	can_shoot = false
	start_firerate_timer()
