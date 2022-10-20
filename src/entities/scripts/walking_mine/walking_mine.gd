extends KinematicBody2D


const PAYLOAD_TYPE: String = "DROP_BOT"

enum{
	APPROACHING
	WAITING,
	CARRIED,
	RELEASED,
	ARMED
}

export (int) var speed = 60

var active: bool = false
var current_state: int
var dmg: int = 200
var health: int = 40
var object_type: String = "enemy"
var ExplosionObj: PackedScene = preload("res://src/objects/effects/explosions/scenes/bomb_explosion_small.tscn")
var snap_vector: Vector2
var velocity: Vector2

onready var animation: AnimationPlayer = $Sprite/AnimationPlayer
onready var countdown_timer: Timer = $engine/countdown_timer

func apply_damage(dmg: int):
	health -= dmg

func carried():
	set_collision_mask_bit(1, false)
	current_state = CARRIED
	$Sprite/AnimationPlayer.play("crouch")
	set_physics_process(false)

func dropped(pos: Vector2):
	# This is the function that will be called if it was dropped
	set_physics_process(true)
	set_collision_mask_bit(1, true)
	position = pos
	active = true
	current_state = RELEASED

func _process(delta):
	if health <= 0:
		var explosion: Node2D = ExplosionObj.instance()
		$activation_sensor.monitoring = false
		explosion.initialize(0, position, 0)
		get_parent().add_child(explosion)
		if current_state == CARRIED:
			# get_parent().DepDrone.current_state = get_parent().DepDrone.RETREAT
			get_parent().refresh()
		queue_free()

func _physics_process(delta):
	if current_state != CARRIED:
		if !is_on_floor():
			velocity.y += Globals.gravity * delta
		else:
			velocity.y = 1
			# if !active && current_state != ARMED:
		snap_vector = Vector2(0,16)
		velocity = move_and_slide_with_snap(velocity,snap_vector,Vector2.UP,true)

func _on_activation_sensor_body_entered(body):
	current_state = ARMED
	animation.play("crouch")
	if countdown_timer.is_stopped():
		countdown_timer.start()

func _on_countdown_timer_timeout():
	var explosion_obj: Node = ExplosionObj.instance()
	explosion_obj.initialize(dmg, global_position, Globals.EP_LAYER)
	get_parent().add_child(explosion_obj)
	queue_free()
