extends Control

export (String) var version

enum ERROR {
	GEN_ERROR, # Obviosly a general error bruh
	NO_COMMAND_ERROR, # if the specified error doesn't exist
	FILE_NOT_EXIST # If the specified file tried to be opened
}

var maps_path: String = "res://debug/debug_data/tilemaps"
var display: String = "Debug Console\nVersion: %s\n-------------------------"

var command_error_prompt: String = """
Command: {command} doesn't exist
Makesure that your command is spelled correctly
"""
var general_error_prompt: String = """
Command can't be understood: General Error
"""
var file_not_exist_prompt: String = """
File %s doesn't exist, double check it again.
"""

var debug_object: Object # This is the object that you want to debug

onready var line_edit: LineEdit = get_node("MarginContainer/VBoxContainer/LineEdit")
onready var text_edit: TextEdit = get_node("MarginContainer/VBoxContainer/TextEdit")

func _ready():
	clear()


func set_debug_object(obj: Object):
	debug_object = obj


func debug_object_state(data: Array = []):
	if debug_object == null:
		prompt("No debug object set!")
		return
	
	if debug_object.has_method("get_state"):
		prompt("The debug object state is: " + str(debug_object.get_state()))
		return
	
	else:
		prompt("Debug object: " + str(debug_object.name) + " has no method get_state()")


func get_player_state(data: Array = []):
	# This will print the current state of the player
	if Globals.player != null:
		prompt(Globals.player.get_state())


func save_map(data: Array = []):
	var save_name: String = data[0]
	var tilemap: TileMap = Globals.level.get_tilemap()
	var tilemap_pack: PackedScene = PackedScene.new()
	tilemap_pack.pack(tilemap)
	var err: = ResourceSaver.save(maps_path.plus_file(save_name + ".tscn"),
			tilemap_pack)
	prompt(str(err))


func load_map(data: Array = []):
	var filename_ = maps_path.plus_file(data[0]+".tscn")
	var map_scene: = load(filename_)
	if map_scene == null:
		show_error("load_map", ERROR.FILE_NOT_EXIST, 
				{"filename": filename_})
		return
	Globals.level.change_map(map_scene)


func clear(data: Array = []):
	text_edit.set_text(display%version)


func help(data: Array = []):
	var text: String = """
---------------------------------------------
Help as of version: %s

NOTE_1: This console is case sensitive!

"help"\t Prints this junk
"clear"\t Clears the screen
"get_player_state"\t Prints the player state
"save_map"\t Save the current map on the default directory
"load_map"\t Load map and change the current map
"debug_object_state"\t Prints the current state of the debugged object
---------------------------------------------
	"""
	prompt(text%version)

 
func show_error(command: String = "", err_name: int = -1, params: Dictionary={}):
	if err_name == ERROR.GEN_ERROR:
		prompt(general_error_prompt)
	elif err_name == ERROR.NO_COMMAND_ERROR:
		prompt(command_error_prompt.format({command=command}))
	elif err_name == ERROR.FILE_NOT_EXIST:
		prompt(file_not_exist_prompt%params["filename"])


func prompt(text: String):
	text_edit.text += "\n" + text


func _on_LineEdit_text_entered(new_text):
	line_edit.set_text("")
	new_text = new_text.strip_edges()
	var command_array: Array = new_text.split(" ")
	var command: String = command_array.pop_front()
	var parameter: Array = command_array
	if has_method(command):
		callv(command, [parameter])
	else:
		show_error(command, ERROR.NO_COMMAND_ERROR)
