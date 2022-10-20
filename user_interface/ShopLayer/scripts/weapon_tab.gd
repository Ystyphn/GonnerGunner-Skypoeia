extends MarginContainer

var forbidden_keys: Array = ["currency", "bullet_speed", "iconPath", "sprite_path"]

onready var items_container: VBoxContainer = get_node("ItemTab/ItemsScroll/Items")
onready var item_image: TextureRect = get_node("ItemTab/Preview/HBoxContainer2/TextureRect")
onready var description: Label = get_node("ItemTab/Preview/HBoxContainer/ScrollContainer/VBoxContainer/Description")

func connect_items():
	for item in items_container.get_children():
		item.connect("pressed", self, "show_description", [item.data, item.id])

func preview_texture(img: Texture):
	# This will show the item image in the description section
	item_image.set_texture(img)

func show_description(data: Dictionary, id: String):
	description.set_text("name : %s\n" % id)
	var item_texture: Texture = load(data["iconPath"])
	preview_texture(item_texture)
	var data_keys: Array = data.keys()
	for key in forbidden_keys:
		data_keys.erase(key)
	for key in data_keys:
		description.text += "{key} : {content}\n".format({"key": key, "content": data[key]})

func _ready():
	$ItemTab/Preview/HBoxContainer/VBoxContainer/Buttons/Close.connect("pressed", ShopLayer, "hide")
