extends Node


var current_weapons: Array = [] # Must not contain more than 2 elements
var upgraded_weapons: Dictionary
var weapons: Dictionary
var misc: Dictionary


func add_misc_item(item: Node):
	var key: String = item.db_id
	if misc.has(key):
		misc[key] += 1
	else:
		misc[key] = 1

func add_upgraded_weapon(weapon: Node):
	var key: String = weapon.db_id
	if upgraded_weapons.has(key):
		upgraded_weapons[key].append(weapon.get_data())
	else:
		upgraded_weapons[key] = [weapon.get_data()]

func add_weapon(weapon: Node):
	var key: String = weapon.db_id
	if weapons.has(key):
		weapons[key] += 1
	else:
		weapons[key] = 1
