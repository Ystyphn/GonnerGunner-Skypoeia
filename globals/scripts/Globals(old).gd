extends Node2D


# Data related constants
const DATA_PATH: String = "res://data"
const ERROR_NOTIF: String = "Something silly happened!!! >__<"
const PLAYER_FILE: String = "players.tres"
# const ScoreSaver = preload("res://debug/scripts/data_scripts/ScoreSaver.gd")
const PlayerDatabase = preload("res://debug/scripts/data_scripts/UserSaver.gd")
const BaseScene: PackedScene = preload("res://src/main/scenes/base/Base.tscn")

# AudioObjects
const EXPLOSION: AudioStream = preload("res://assets/sounds/sfx/missile_explosion.wav")
const GUN_SHOT_1: AudioStream = preload("res://assets/sounds/sfx/gun_shot_1.wav")
const JUMP: AudioStream = preload("res://assets/sounds/sfx/player_jump.wav")
const HURT: AudioStream = preload("res://assets/sounds/sfx/player_hurt.wav")
const DEAD: AudioStream = preload("res://assets/sounds/sfx/player_dead.wav")
const ENEMY_DEAD: AudioStream = preload("res://assets/sounds/sfx/entity_explosion.wav")
const TRAPDOOR_SOUND: AudioStream = preload("res://assets/sounds/sfx/trapdoor_shape1.wav")
const WALKING: AudioStream = preload("res://assets/sounds/sfx/walking.wav")
const SHOTGUN_RELOAD: AudioStream = preload("res://assets/sounds/sfx/shotgun_reload.wav")
const SHOTGUN_BLAST: AudioStream = preload("res://assets/sounds/sfx/shotgun.wav")

# These are the Collision Masks
const ALL_MB: int = 207
const DEFAULT_MB: int = 9 # collide only to the world and breakables
const ENEMY_MB: int = 141
const NO_MB: int = 0
const PLAYER_MB: int = 75

# These are the Collision Layers
const ENEMY_LAYER: int = 2
const EP_LAYER: int = 256 # Enemy projectile layer
const PLAYER_LAYER: int = 4
const PP_LAYER: int = 512 # Player Projectile

# This is the player's database
var db_file: String = DATA_PATH.plus_file(PLAYER_FILE)


var Main: PackedScene = preload("res://src/main/scenes/Main.tscn")
var QuickGame: PackedScene = preload("res://game_modes/quick_game/scenes/QuickGame.tscn")
var AudioPlayer: PackedScene = preload("res://src/objects/effects/sound/scenes/AudioPlayer.tscn")
var Math: Object = preload("res://globals/scripts/my_math.gd").new()

# These are the runtime object variables
var Player: KinematicBody2D = null

var focused: bool = true
var gravity: int = 800
var player_alive: bool = false
var test_payload: PackedScene = preload("res://debug/scenes/objects/GODOT.tscn")
var walking_mine: PackedScene = preload("res://src/entities/scenes/walking_mine/WalkingMine.tscn")
var RO_01: PackedScene = preload("res://src/objects/missiles/scenes/RO-01.tscn")
var dir: Directory = Directory.new()
var highscore: int = 0
var player_dead: bool = false
var ingame: bool = false
var paused: bool = false
var DatabasePath: String = DATA_PATH.plus_file(PLAYER_FILE)

# These are the audio variables
var sfx_volume: float
var music_volume: float

onready var hpBar: TextureProgress = get_node("/root/PlayerUi").hpBar
onready var boostBar: TextureProgress = get_node("/root/PlayerUi").boostBar

func add_new_player(player: Node, username: String):
	var player_database: Resource = load(DatabasePath)
	player_database.data[username] = player
	var error = ResourceSaver.save(DatabasePath, player_database)
	if error == OK:
		print("New user: {username}, was added!!!".format({"username": username}))
	else:
		print(ERROR_NOTIF)
		print("Error code: ", error)

func get_player(username: String):
	var players_database: Resource = load(DatabasePath)
	var player_names: Array = players_database.data.keys()
	if username in player_names:
		return players_database.data[username]
	else:
		return "No user like that"

func clear_ui():
	Notifier.get_node("Control").set_visible(false)
	Menu.get_node("Control").set_visible(false)
	PlayerUi.get_node("playerUI").set_visible(false)
	GameOverScreen.get_node("Control").set_visible(false)
	MainMenu.set_visible(false)

func set_ingame(flag: bool):
	# Determine whether you are in main menu or playing
	if flag:
		MainMenu.set_visible(false)
		PlayerUi.get_node("playerUI").set_visible(true)
	ingame = flag

func fade_in():
	FadeCover.get_node("AnimationPlayer").play("fade_in")

func fade_out():
	FadeCover.get_node("AnimationPlayer").play("fade_out")

func fade_out_to(scene: PackedScene): # This will fade in redirect us to other scene
	FadeCover.connect("animation_finished",self, "switch_to_scene",[scene])
	fade_out()

func get_percent(whole: float, part: float):
	var percent: float = part / whole
	percent *= 100
	return percent

func initialize_game_data(weapon_data: Dictionary):
	"""
	var player_database = PlayerDatabase.new()
	var weapon: Node = GunCreator.create_pistol(weapon_data)
	player_database.add_weapon_object(weapon)
	var dir: Directory = Directory.new()
	var error = ResourceSaver.save(db_file, player_database)
	if error == OK:
		print("Successfully saved database")
		InitWepChoice.get_node("Control").set_visible(false)
	else:
		print("Something silly happened")
		print("Error code: ", error)"""
	pass

func main_menu():
	clear_ui()
	MainMenu.set_visible(true)
	set_ingame(false)
	get_tree().change_scene_to(Main)

func play_audio(pos: Vector2, audio: AudioStream):
	var audio_player: AudioStreamPlayer2D = AudioPlayer.instance()
	audio_player.setup(pos, audio)
	get_tree().get_root().add_child(audio_player)

func start_quickgame():
	fade_in()
	yield(FadeCover.get_node("AnimationPlayer"),"animation_finished")
	PlayerUi.update_score(0)
	get_tree().change_scene_to(QuickGame)

func set_payload_of(carrier: Node, payload: Node):
	carrier.get_node("payload").carry(payload)

func restart():
	PlayerUi.update_score(0)
	PlayerUi.update_wave(1)
	get_tree().change_scene_to(QuickGame)

func start_game():
	MainMenu.set_visible(false)

func switch_to_scene(scene: PackedScene):
	fade_in()
	yield(FadeCover.get_node("AnimationPlayer"), "animation_finished")
	get_tree().change_scene_to(scene)

func save_data():
	pass

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		get_tree().call_group("controllers", "reset_move_switches")
		get_tree().paused = true
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		if !paused:
			get_tree().paused = false
	elif what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().set_pause(true)
		ExitConfirm.get_node("Popup").popup()

func _ready():
	get_tree().set_auto_accept_quit(false)
	#if !dir.file_exists(DATA_PATH.plus_file(PLAYER_FILE)):
	#	InitWepChoice.get_node("Control").set_visible(true)
	OS.set_min_window_size(Vector2(600, 400))
