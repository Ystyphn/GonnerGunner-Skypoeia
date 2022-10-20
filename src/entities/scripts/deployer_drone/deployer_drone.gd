extends KinematicBody2D


export (int) var speed = 45

enum{
	APPROACH,
	RETREAT
}

var Explosion: PackedScene = preload("res://src/objects/effects/explosions/scenes/bomb_explosion_small.tscn")
var missile_launch: AudioStream = preload("res://assets/sounds/sfx/missle_launch.wav")

var type: String = "carrier"
var current_state: int = APPROACH
var object_type: String = "enemy"
var health: int = 35
var velocity: Vector2
var points: int = 10

onready var parent: Node = get_parent()
onready var animation: AnimationPlayer = $Sprite/AnimationPlayer
onready var payload_node: Node = $payload

func activate():
	$engine/AI.target = parent.player if parent.player else parent.ship
	$engine/AI.set_physics_process(true)

func apply_damage(damage: int):
	health -= damage

func return_angle_to(point: Vector2):
	return get_angle_to(point)

func _process(delta):
	if health <= 0:
		var explosion: Node2D = Explosion.instance()
		explosion.initialize(0, global_position, Globals.NO_MB)
		get_parent().add_child(explosion)
		get_parent().total_spawned_enemies -= 1
		#if get_parent().name == "quick_game":
		get_parent().update_points(points)
		Globals.play_audio(global_position, Globals.ENEMY_DEAD)
		queue_free()

func _physics_process(delta):
	move_and_slide(velocity)
	if current_state == RETREAT:
		if position.x < -70 || position.x > 1076 || position.y < -1090 || position.y > 650:
			get_parent().total_spawned_enemies -= 1
			get_parent().enemy_queue
			queue_free()

func _ready():
	animation.play("fly_free")
	add_to_group("enemies")
	add_to_group("carriers")
	activate()
	# $engine/AI.set_physics_process(false)
