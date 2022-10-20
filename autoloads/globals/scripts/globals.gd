extends Node


const THREAD_COUNT: int = 4

export (int) var gravity = 600

var game_scene: BaseScene
var player
var interactable
var door
var threads: Array

func _ready():
	randomize()
	
func _input(event):
	if event.is_action_pressed("console"):
		DebugConsole.show()

func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT:
		get_tree().set_pause(true)
	elif what == NOTIFICATION_WM_FOCUS_IN:
		get_tree().set_pause(false)

