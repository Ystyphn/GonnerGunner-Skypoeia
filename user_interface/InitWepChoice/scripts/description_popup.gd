extends Popup


func console_write(text: String):
	$NinePatchRect/MarginContainer/VBoxContainer/ScrollContainer/Label.set_text(text)

func _on_Button_pressed():
	set_visible(false)
