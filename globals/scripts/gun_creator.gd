extends Node


class_name Gun_Creator

var PistolClass: PackedScene = preload("res://src/objects/guns/scenes/PistolObject/PistolObject.tscn")
var ARClass: PackedScene = preload("res://src/objects/guns/scenes/ARObject/ARObject.tscn")
var SGClass: PackedScene = preload("res://src/objects/guns/scenes/SGObject/SGObject.tscn")
var SMGClass: PackedScene = preload("res://src/objects/guns/scenes/SMGObject/SMGObject.tscn")

func create_pistol(data: Dictionary):
	# Return a complete pistol object passed as parameter
	var new_pistol: Node2D = PistolClass.instance()
	new_pistol.initialize_data(data)
	return new_pistol

func create_ar(data: Dictionary):
	var new_gun: Node2D = ARClass.instance()
	new_gun.initialize(data)
	return new_gun

func create_sg(data: Dictionary):
	var new_gun: Node2D = SGClass.instance()
	new_gun.initialize(data)
	return new_gun

func create_smg(data: Dictionary):
	var new_gun: Node2D = SMGClass.instance()
	new_gun.initialize(data)
	return new_gun
