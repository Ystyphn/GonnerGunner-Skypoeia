extends Node2D

export (int) var damage
export (int) var speed
export (int) var range_
export (float) var pierce
export (int) var max_ammo
export (float) var reload_speed
export (int) var shrapnel_count
export (float) var spread

var Magazine: PackedScene = preload("res://src/objects/effects/modified_particles/scenes/Magazine.tscn")
var BulletCase: PackedScene = preload("res://src/objects/effects/modified_particles/scenes/Bullet_Case.tscn")
var RectBullet: PackedScene = preload("res://src/objects/bullets/scenes/rect_bullet.tscn")

var ammo: int
var can_shoot: bool = true
var db_id: String
var reloading: bool = false
var upgraded: bool = false
var used: bool = true

onready var player: Node = get_parent().get_parent().get_parent()
onready var nozzle: Position2D = $Nozzle
onready var game_scene: Node = get_tree().get_root() 

func generate_angle_spread():
	return rand_range(-spread, spread)

func fire():
	reloading = false
	if !$reload_speed.is_stopped():
		$reload_speed.stop()
	if can_shoot:
		for shard in shrapnel_count:
			var bullet: Node = RectBullet.instance()
			var spread_angle: float = generate_angle_spread()
			var abs_angle: float = player.get_angle_to(get_global_mouse_position())
			abs_angle += deg2rad(spread_angle)
			bullet.initialize(nozzle.global_position, 
					abs_angle , damage, speed, range_, Globals.NO_MB)
			game_scene.add_child(bullet)
		can_shoot = false
		$AnimationPlayer.play("gunfire")
		Globals.play_audio(nozzle.global_position, Globals.SHOTGUN_BLAST)
		var bullet_case: RigidBody2D = BulletCase.instance()
		bullet_case.set_position($EjectionPos.global_position)
		bullet_case.initialize(player.flipped)
		get_tree().get_root().add_child(bullet_case)
		ammo -= 1

func initialize_data(data: Dictionary):
	var sprite_texture: Texture = load(data["sprite_path"])
	$Sprite.set_texture(sprite_texture)
	self.db_id = data["name"]
	self.damage = data["damage"]
	self.speed = data["bullet_speed"]
	self.range_ = data["range"]
	self.inaccuracy = data["inaccuracy"]
	self.pierce = data["pierce"]
	self.max_ammo = data["max_ammo"]
	$reload_speed.set_wait_time(reload_speed)
	$reload_speed.start()

func reload():
	if !reloading:
		reloading = true
		if $reload_speed.is_stopped():
			$reload_speed.start()

func using(flag: bool):
	set_process_unhandled_input(flag)
	set_visible(flag)
	used = flag

func _physics_process(_delta):
	look_at(get_global_mouse_position())

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		if ammo > 0:
			fire()
	if event.is_action_released("left_click"):
		can_shoot = true
	if event.is_action_pressed("reload"):
		reload()

func _ready():
	# $gun_fire.set_visible(false)
	ammo = max_ammo
	$reload_speed.set_wait_time(reload_speed)

func _on_reload_speed_timeout():
	if ammo < max_ammo:
		ammo += 1
		Globals.play_audio(global_position,Globals.SHOTGUN_RELOAD)
		$reload_speed.start()
