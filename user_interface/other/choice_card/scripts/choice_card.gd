extends NinePatchRect

var data: Dictionary
var name_: String

func initialize(data: Dictionary, name_: String = ""):
	var icon: Texture = load(data["iconPath"])
	$MarginContainer/VBoxContainer/TextureRect.set_texture(icon)
	self.data = data
	self.name_ = name_
