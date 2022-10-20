extends CanvasLayer


func _on_Yes_pressed():
	get_tree().quit()

func _on_No_pressed():
	if !Globals.paused:
		get_tree().set_pause(false)
	$Popup.set_visible(false)
