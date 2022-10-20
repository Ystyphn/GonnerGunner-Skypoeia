extends Sprite


const PAYLOAD_TYPE: String = "MISSILE"
const SPEED: int = 450

var Explosion: PackedScene = preload("res://src/objects/effects/explosions/scenes/bomb_explosion_small.tscn")

var damage: int = 150
var locked: bool = false
var max_range: int = 500
var released: bool = false
var starting_pos: Vector2
var target: Node = null
var target_angle: float
var target_point: Vector2
var velocity: Vector2

func carried():
	released = false
	$Particles2D.set_emitting(false)

func dropped(pos: Vector2):
	set_position(pos)
	starting_pos = pos
	released = true
	$Particles2D.set_emitting(true)
	target_point = target.global_position
	target_angle = get_parent().get_parent().get_angle_to(target.position)
	velocity.x = cos(target_angle) * SPEED
	velocity.y = sin(target_angle) * SPEED
	set_rotation(target_angle)

func get_angle_to_(point: Vector2):
	var rad: float = atan2(point.y - global_position.y, point.x - global_position.x)
	return rad

func set_target(target_: Node):
	target = target_

func _physics_process(delta):
	if released:
		position.x += velocity.x * delta
		position.y += velocity.y * delta
		if (position - starting_pos).length() >= max_range:
			var explosion: Node = Explosion.instance()
			explosion.position = position
			get_parent().add_child(explosion)
			queue_free()
	else:
		look_at(get_parent().get_parent().get_node("engine/AI").target.global_position)

func _ready():
	# set_physics_process(false)
	# set_target(get_parent().get_parent().get_parent().player)
	$Area2D.set_collision_mask(Globals.ENEMY_MB)

func _on_Area2D_body_entered(body):
	velocity = Vector2.ZERO
	var explosion: Node = Explosion.instance()
	explosion.initialize(damage, position, Globals.EP_LAYER)
	get_parent().add_child(explosion)
	Globals.play_audio(global_position, Globals.EXPLOSION)
	queue_free()
