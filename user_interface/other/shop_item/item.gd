extends Button

var data: Dictionary
var id: String

func initialize(id: String, item_type: String):
	# Get the id of the desired weapon
	# Load that id
	if item_type == "pistol":
		self.data = ResLoader.get_gun_data(id, ResLoader.pistols_data_path)
		self.id = id
	elif item_type == "AR":
		self.data = ResLoader.get_gun_data(id, ResLoader.ar_data_path)
		self.id = id
	elif item_type == "SMG":
		self.data = ResLoader.get_gun_data(id, ResLoader.smg_data_path)
		self.id = id
	elif item_type == "SG":
		self.data = ResLoader.get_gun_data(id, ResLoader.sg_data_path)
		self.id = id
	else:
		print("No ",item_type, " found in data base")
	load_details()

func load_details():
	# This will load necessary details for the button
	# Only works if the data has necessary elements
	if data.size() > 0:
		var icon_path: String = data["iconPath"]
		var _icon: Texture = load(icon_path)
		$HBoxContainer/Identification/Icon.set_texture(_icon)
		$HBoxContainer/Identification/NameScroll/Label.set_text(self.id)
		$HBoxContainer/Description/Damage/Label.set_text(str(data["damage"]))
		$HBoxContainer/Description/Ammo/Label.set_text(str(data["max_ammo"]))
		$HBoxContainer/Description/Price/Label.set_text(str(data["price"]))
