extends CanvasLayer


onready var control: Control = $Control

func main_menu():
	control.set_visible(false)
	get_tree().set_pause(false)
	Globals.paused = false
	Globals.main_menu()

func show(switch: bool):
	Globals.paused = switch
	control.set_visible(switch)
	get_tree().set_pause(switch)

func _ready():
	$Control/NinePatchRect/VBoxContainer/Resume.connect("pressed", self, "show", [false])
	$Control/NinePatchRect/VBoxContainer/MainMenu.connect("pressed", self, "main_menu")

func _on_Options_pressed():
	SettingsScreen.get_node("Control").set_visible(true)
