extends Node2D

var ship: Node
var player: Node

func _ready():
	Globals.fade_out()
	Globals.clear_ui()
