extends KinematicBody2D

export (int) var speed
export (int) var damage = 2

var can_shoot: bool = true
var type: String = "fighter"
var object_type: String = "enemy"
var health: int = 70
var velocity: Vector2
var points: int = 5

var Bullet: PackedScene = preload("res://src/objects/bullets/scenes/round_bullet/round_bullet.tscn")
var ExplosionScene: PackedScene = preload("res://src/objects/effects/explosions/scenes/bomb_explosion_small.tscn")

onready var ai: Node2D = $engine/AI
onready var animation: AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var parent: Node2D = get_parent()

func apply_damage(dmg):
	health -= dmg

func shoot(pos = null):
	if !pos:
		var radians = get_angle_to($engine/AI.target.global_position)
		var bullet: Node = Bullet.instance()
		bullet.initialize($Sprite/Position2D.global_position,radians, damage, 80,150,Globals.ENEMY_MB)
		get_parent().add_child(bullet)
		can_shoot = false
		if $engine/firerate.is_stopped():
			$engine/firerate.start()
	else:
		var radians = get_angle_to(pos)
		var bullet: Node = Bullet.instance()
		bullet.initialize($Sprite/Position2D.global_position,radians, damage, 80,150,Globals.ENEMY_MB)
		get_parent().add_child(bullet)
		can_shoot = false
		if $engine/firerate.is_stopped():
			$engine/firerate.start()

func _process(delta):
	if health <= 0:
		var boom: Node2D = ExplosionScene.instance()
		boom.initialize(0, global_position, Globals.NO_MB)
		parent.add_child(boom)
		get_parent().total_spawned_enemies -= 1
		Globals.play_audio(global_position, Globals.ENEMY_DEAD)
		get_parent().update_points(points)
		queue_free()

func _physics_process(delta):
	move_and_slide(velocity)

func _ready():
	animation.play("fly")
	add_to_group("enemies")
	add_to_group("fighters")
	# $engine/AI.set_physics_process(false)

func _on_firerate_timeout():
	can_shoot = true
