class_name GunClass
extends Node2D


export (int) var damage = 30
export (int) var max_ammo = 30
export (int) var max_range = 350
export (float) var bullet_speed = 600.0
export (float) var pierce
export (float) var crit_chance
export (float) var crit_multiplier
export (float) var firerate
export (float) var reload_time 

export (NodePath) var sprite_path
export (NodePath) var animation_player_path
export (NodePath) var bullet_spawn_point_path
export (NodePath) var shell_exit_point_path
export (NodePath) var magazine_spawn_point_path
export (NodePath) var firerate_timer_path
export (NodePath) var reload_time_timer_path

export (PackedScene) var gunfire_scene
export (PackedScene) var bullet_scene

var remaining_ammo: int
var can_shoot: bool = true
var shooting: bool = false 

onready var sprite: Sprite = get_node(sprite_path)
onready var animation_player: = get_node(animation_player_path)
onready var bullet_spawn_point: = get_node(bullet_spawn_point_path)
onready var shell_exit_point: = get_node(shell_exit_point_path)
onready var magazine_spawn_point:= get_node(magazine_spawn_point_path)
onready var firerate_timer: Timer = get_node(firerate_timer_path)
onready var reload_time_timer: Timer = get_node(reload_time_timer_path)

func set_frame(frame: int):
	sprite.set_frame(frame)

func set_animation(anim: String):
	animation_player.play(anim)

func set_firerate(value: float = 1.0):
	firerate = value
	$FireRate.set_wait_time(value)

func set_bullet_scene(scene: PackedScene):
	bullet_scene = scene

func set_bullet_scene_from_path(path: String):
	bullet_scene = load(path)

func set_reload_time(time: float =1.0):
	reload_time = time
	$ReloadTime.set_wait_time(time)

func start_firerate_timer():
	# This, obviously, will start the timer countdown if it hasn't started yet
	if $FireRate.is_stopped():
		$FireRate.start()

func firerate_timeout():
	can_shoot = true
