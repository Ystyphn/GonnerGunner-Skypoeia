extends CanvasLayer

var ItemClass: PackedScene = preload("res://src/user_interface/other/inventory_button/scenes/InventoryButton.tscn")

func is_database_exist():
	var dir: Directory = Directory.new()
	if dir.file_exists(Globals.db_file):
		return true
	else:
		return false

func _ready():
	# Check inventory
	if is_database_exist():
		var db: Resource = load(Globals.db_file)
		var weapons: Dictionary = db.load_weapons()
