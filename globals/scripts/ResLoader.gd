extends Node

# Files and path
const SHOPDATA_PATH: String = "res://data/game_resources/shop_data/weapons/"
const PLAYERS_FILE: String = "res://data/players.tres"
const AR_FILE: String = "assault_rifles.txt"
const PISTOL_FILE: String = "pistols.txt"
const SG_FILE: String = "shotguns.txt"
const SMG_FILE: String = "submachineguns.txt"

# Weapons' data paths
var directory: Directory = Directory.new()
var pistols_data_path: String = SHOPDATA_PATH.plus_file(PISTOL_FILE)
var ar_data_path: String = SHOPDATA_PATH.plus_file(AR_FILE)
var sg_data_path: String = SHOPDATA_PATH.plus_file(SG_FILE)
var smg_data_path: String = SHOPDATA_PATH.plus_file(SMG_FILE)

func get_gun_data(name_: String, data_path: String):
	var file: File = File.new()
	file.open(data_path, File.READ)
	var guns: Dictionary = str2var(file.get_as_text())
	file.close()
	return guns[name_]

func get_gun_element(name_: String, element: String):
	var file: File = File.new()
	# file.open(data_path)

func get_player_data(name_: String):
	var players_res: Resource = load(PLAYERS_FILE)
	var player = players_res.data[name_]
	players_res = null
	return player
	pass

func load_weapon_ids(data_path: String):
	var file: File = File.new()
	file.open(data_path, File.READ)
	var weapon_ids: Array = str2var(file.get_as_text()).keys()
	file.close()
	weapon_ids.erase("version")
	return weapon_ids

# These are some id related functions
func load_pistol_ids() -> Array:
	var file: File = File.new()
	file.open(pistols_data_path, File.READ)
	var pistol_datas: Dictionary = str2var(file.get_as_text())
	pistol_datas.erase("version")
	file.close()
	var pistol_keys: Array = pistol_datas.keys()
	return pistol_keys
