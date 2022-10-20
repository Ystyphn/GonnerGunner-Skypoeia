extends Resource

const STACK_SUFFIX: String = "_stack"

var version: String = ProjectSettings.get_setting("application/config/version")
export var primary_gun: String
export var secondary_gun: String
export var player_data: Dictionary = {}
export var weapons: Dictionary = {}
export var misc: Dictionary = {}

func add_weapon_object(weapon: Node):
	var key: String = weapon.db_id
	if !weapon.upgraded:
		if weapons.has(key):
			weapons[key] += 1
		else:
			weapons[key] = 1

func append_misc(name_: String):
	if misc.has(name_):
		misc[name_] += 1
	else:
		misc[name_] = 1

func load_weapons():
	return weapons
