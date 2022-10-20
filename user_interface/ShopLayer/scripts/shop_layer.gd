extends CanvasLayer


var ItemButton: PackedScene = preload("res://src/user_interface/other/shop_item/Item.tscn")

func hide():
	if !Globals.paused:
		get_tree().set_pause(false)
	$Control.set_visible(false)

func initialize():
	var pistol_ids: Array = ResLoader.load_weapon_ids(ResLoader.pistols_data_path)
	var ar_ids: Array = ResLoader.load_weapon_ids(ResLoader.ar_data_path)
	var smg_ids: Array = ResLoader.load_weapon_ids(ResLoader.smg_data_path)
	var sg_ids: Array = ResLoader.load_weapon_ids(ResLoader.sg_data_path)
	for id in pistol_ids:
		var item_button: Button = ItemButton.instance()
		item_button.initialize(id, "pistol")
		$Control/MarginContainer/TabContainer/Weapons/Pistols/ItemTab/ItemsScroll/Items.add_child(item_button)
	for id in ar_ids:
		var item_button: Button = ItemButton.instance()
		item_button.initialize(id, "AR")
		$Control/MarginContainer/TabContainer/Weapons/AR/ItemTab/ItemsScroll/Items.add_child(item_button)
	for id in smg_ids:
		var item_button: Button = ItemButton.instance()
		item_button.initialize(id, "SMG")
		$Control/MarginContainer/TabContainer/Weapons/SMG/ItemTab/ItemsScroll/Items.add_child(item_button)
	for id in sg_ids:
		var item_button: Button = ItemButton.instance()
		item_button.initialize(id, "SG")
		$Control/MarginContainer/TabContainer/Weapons/SG/ItemTab/ItemsScroll/Items.add_child(item_button)
	for weapon_tab in $Control/MarginContainer/TabContainer/Weapons.get_children():
		weapon_tab.connect_items()

func show():
	get_tree().set_pause(true)
	$Control.set_visible(true)

func _ready():
	initialize()
