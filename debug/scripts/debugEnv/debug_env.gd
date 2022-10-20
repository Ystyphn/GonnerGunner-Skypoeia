extends Node2D


const CAMLIMIT_LEFT: int = 0
const CAMLIMIT_RIGHT: int = 1024
const CAMLIMIT_TOP: int = 0
const CAMLIMIT_BOTTOM: int = 1024

var player: KinematicBody2D

func _unhandled_input(event):
	pass

func set_camera_limit(camera: Camera2D):
	camera.limit_left = CAMLIMIT_LEFT
	camera.limit_right = CAMLIMIT_RIGHT
	camera.limit_top = CAMLIMIT_TOP
	camera.limit_bottom = CAMLIMIT_BOTTOM

func _ready():
	#Globals.set_payload_of($Deployer_Drone,Globals.RO_01.instance())
	#Globals.clear_ui()
	#Globals.fade_out()
	pass
