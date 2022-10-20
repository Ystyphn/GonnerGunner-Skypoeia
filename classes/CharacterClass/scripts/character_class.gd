class_name CharacterClass
extends EntityClass

export (int) var air_speed = 45 # this will be the speed whenever this character
# is in the air
export (int) var climb_speed = 45
export (float) var autojump_strength = 76
export (NodePath) var animation_player_path
export (NodePath) var sprite_path
export (NodePath) var current_weapon_path
export (NodePath) var camera_path

var ship: ShipClass # This will be the player's reference to the ship if he is in the
# collision of the ship
var command_computer: CommandComputerClass # This will be the reference of the player
# when it sits on the command computer
var snap_vector: Vector2 = Vector2(0,8)
var on_ladder_area: bool = false
var ladder # This is the reference to the ladder object itself
var interactable_object # This is the interactable
var can_shoot: bool = true
var tile_detected_1: bool = false # This is the tile that is being detected
# in the head
var tile_detected_2: bool = false # The tile detector in the foot
var collision_point: Vector2

onready var jetpack_node: Node2D = get_node("JetpackNode")
onready var animation_player: AnimationPlayer = get_node(animation_player_path)
onready var sprite: Sprite = get_node(sprite_path)
onready var current_weapon: Node = get_node(current_weapon_path)
onready var camera: Camera2D = get_node(camera_path)
onready var detector_1: RayCast2D = get_node("TileDetectors/Detector1")
onready var detector_2: RayCast2D = get_node("TileDetectors/Detector2")
onready var tile_detectors: TileDetectors = get_node("TileDetectors")

func _ready():
	Globals.player = self

func do_autojump():
	return tile_detectors.do_autojump()

func _physics_process(delta):
	pass

func manage_facing():
	if get_global_mouse_position().x < global_position.x:
		sprite.scale.x = -1
	elif get_global_mouse_position().x > global_position.x:
		sprite.scale.x = 1

func is_collision_on_dir(dir: int):
	return tile_detectors.is_collision_on_dir(dir)

func set_state(new_state: String):
	state_machine.transition_to(new_state)

func get_state():
	return state_machine.get_state()

func set_animation(anim: String, backwards: bool = false) -> void:
	animation_player.play(anim, backwards)

func stop_animation(reset: bool = true):
	animation_player.stop(reset)

func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_IN:
		set_state("Idle")

