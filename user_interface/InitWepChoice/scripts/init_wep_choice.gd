extends CanvasLayer

# const ChoiceCard: PackedScene = preload("res://src/user_interface/other/choice_card/scenes/ChoiceCard.tscn")


func set_starting_weapon(data: Dictionary, name_: String):
	print("Setting %s as default!" % name_)

func show_description(data: Dictionary, name_: String):
	var description: String = "NAME: %s\n" % name_
	var keys: Array = data.keys()
	var forbidden_keys: Array = ["sprite_path", "iconPath", "price", "currency"]
	for key in forbidden_keys:
		keys.erase(key)
	for key in keys:
		var description_line: String = "{key}: {data}\n".format({"key":key, "data":data[key]})
		description += description_line
	$Popup.console_write(description)
	$Popup.popup()

func _ready():
	"""var pistol_names: Array = ResLoader.load_pistol_ids()
	for name_ in pistol_names:
		var choice_card: Node = ChoiceCard.instance()
		var description_button_path: String = "MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Description"
		var choose_button_path: String = "MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Choose"
		choice_card.initialize(ResLoader.get_gun_data(name_, ResLoader.pistols_data_path), name_)
		choice_card.get_node(description_button_path).connect("pressed", self,
				"show_description", [choice_card.data, choice_card.name_])
		choice_card.get_node(choose_button_path).connect("pressed", Globals,
				"initialize_game_data", [choice_card.data])
		$Control/HBoxContainer.add_child(choice_card)"""
	pass
