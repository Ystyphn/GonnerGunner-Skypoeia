extends CanvasLayer


const USERKEY: PackedScene = preload("res://src/user_interface/other/user_button/UserButton.tscn")
const DELETE_CONFIRM: String = "Are you sure you want to delete %s?"


func close_deletion():
	$Control/DeleteConfirmPopup.set_visible(false)
	$Control/DeleteConfirmPopup/NinePatchRect2/VBoxContainer/HBoxContainer/Yes.disconnect("pressed", 
			self, "delete_player")

func confirm_delete(id: String):
	# This will just popup some confirmation to delete a certain player
	$Control/DeleteConfirmPopup/NinePatchRect2/VBoxContainer/Label.set_text(DELETE_CONFIRM % id)
	$Control/DeleteConfirmPopup.popup()
	$Control/DeleteConfirmPopup/NinePatchRect2/VBoxContainer/HBoxContainer/Yes.connect("pressed",
			self, "delete_player", [id])
	$Control/DeleteConfirmPopup/NinePatchRect2/VBoxContainer/HBoxContainer/No.connect("pressed", 
			self, "close_deletion")

func delete_player(id: String):
	# This will delete the player desired
	close_deletion()
	var players: Resource = load(Globals.DATA_PATH.plus_file(Globals.PLAYER_FILE))
	players.data.erase(id)
	var error: int = ResourceSaver.save(Globals.DatabasePath, players)
	if error != OK:
		print(Globals.ERROR_NOTIF)
		print("Error code: ", error)
		return
	update_player_list()

func get_player_names():
	# Return all names avaiable in database
	var players: Resource = load(Globals.DATA_PATH.plus_file(Globals.PLAYER_FILE))
	var player_names: Array = players.data.keys()
	return player_names

func load_players():
	var players: Resource = load(Globals.DATA_PATH.plus_file(Globals.PLAYER_FILE))
	var player_names: Array = players.data.keys()
	for name_ in player_names:
		print(players.data[name_].has_node("Sprite"))
		var player_key: NinePatchRect = USERKEY.instance()
		player_key.initialize(name_, self, ["confirm_delete", "play"])
		$Control/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer.add_child(player_key)
		$Control/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer.move_child(player_key, 0)

func play(player: KinematicBody2D):
	Globals.Player = player
	print(player.name)

func update_player_list():
	for child in $Control/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer.get_children():
		if child.name != "CreateNewCharacter":
			$Control/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer.remove_child(child)
	# print($Control/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer.get_children())
	load_players()

func _ready():
	if Globals.database_exist:
		load_players()
		# update_player_list()

func _on_CloseButton_pressed():
	$Control/RegisterPopup.set_visible(false)

func _on_CreateNewCharacter_pressed():
	$Control/RegisterPopup.popup()

func _on_CreateButton_pressed():
	var name_input: String = $Control/RegisterPopup/NinePatchRect/MarginContainer/VBoxContainer/LineEdit.get_text().strip_edges()
	var used_names: Array = get_player_names()
	if not (name_input in used_names) and name_input != "":
		var player_instance: KinematicBody2D = Globals.PlayerScene.instance()
		player_instance.name_ = name_input
		print(player_instance.get_node("Sprite/Jetpack").fuel)
		# player_instance.name = name_input
		Globals.add_new_player(player_instance, name_input)
		$Control/RegisterPopup.set_visible(false)
		update_player_list()
	else:
		$Control/SameNamePopup.popup()

func _on_Close_pressed():
	$Control/SameNamePopup.set_visible(false)

func _on_back_pressed():
	Globals.clear_ui()
	MainMenu.set_visible(true)
