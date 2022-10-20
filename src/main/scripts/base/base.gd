extends Node2D

const CAMLIMIT_LEFT: int = 0
const CAMLIMIT_RIGHT: int = 1024
const CAMLIMIT_TOP: int = 0
const CAMLIMIT_BOTTOM: int = 1024

var player: KinematicBody2D

func initialize(player: KinematicBody2D):
	player.set_position($Position2D.get_position())
	Globals.Player = player
	add_child(player)

func set_camera_limit(camera: Camera2D):
	camera.limit_left = CAMLIMIT_LEFT
	camera.limit_right = CAMLIMIT_RIGHT
	camera.limit_top = CAMLIMIT_TOP
	camera.limit_bottom = CAMLIMIT_BOTTOM

func _ready():
	Globals.clear_ui()
	Globals.fade_out()
