extends CanvasLayer


func show():
	$Control.set_visible(true)

func _on_Restart_pressed():
	Globals.restart()
	$Control.set_visible(false)

func _on_MainMenu_pressed():
	Globals.main_menu()
