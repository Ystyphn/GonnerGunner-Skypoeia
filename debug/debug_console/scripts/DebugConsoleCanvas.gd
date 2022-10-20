extends CanvasLayer


func toggle():
	if visible:
		visible = false
	else:
		visible = true


func set_debug_object(obj: Object):
	get_node("DebugConsole").set_debug_object(obj)
	return
