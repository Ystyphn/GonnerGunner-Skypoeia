extends Control

onready var exit_confirm: Node = $CanvasLayer/NinePatchRect

func _on_ExitButton_pressed():
	exit_confirm.set_visible(true)

func _on_Yes_pressed():
	get_tree().quit()

func _on_No_pressed():
	exit_confirm.set_visible(false)

func _on_StartButton_pressed():
	pass

func _ready():
	$Version.set_text(ProjectSettings.get_setting("application/config/version"))

func _on_Settings_pressed():
	SettingsScreen.get_node("Control").set_visible(true)

func _on_Help_pressed():
	HelpUI.get_node("Control").set_visible(true)

func _on_About_pressed():
	$CanvasLayer/Popup.popup()

func _on_popup_close_pressed():
	$CanvasLayer/Popup.set_visible(false)
