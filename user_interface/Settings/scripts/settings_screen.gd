extends CanvasLayer

onready var sfx_slider: HSlider = get_node("Control/NinePatchRect/VBoxContainer/NinePatchRect/SFX")
onready var music_slider: HSlider = get_node("Control/NinePatchRect/VBoxContainer/NinePatchRect2/Music")

func _process(delta):
	$Control/NinePatchRect/ClearData.set_visible(!Globals.ingame)

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),sfx_slider.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),music_slider.value)

func _on_Fullscreen_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)

func _on_Borderless_toggled(button_pressed):
	OS.set_borderless_window(button_pressed)

func _on_SFX_value_changed(value):
	if value != -40:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),value)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),-80)

func _on_Music_value_changed(value):
	if value != -40:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),value)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),-80)

func _on_Return_pressed():
	SettingsScreen.get_node("Control").set_visible(false)

func _on_ClearData_pressed():
	Globals.update_highscore(10000)
	print("Data Cleared")

func _on_World_value_changed(value):
	if value != -40:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("World"),value)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("World"),-80)
