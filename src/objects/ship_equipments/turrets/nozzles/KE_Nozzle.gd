extends Node2D

export (PackedScene) var BulletScene

var bullet_speed: int = 230
var can_shoot: bool = true
var damage: int = 10
var range_: int = 200
var target: Node = null

onready var animation: AnimationPlayer = $Sprite/AnimationPlayer
onready var nozzlePos: Position2D = $Sprite/Position2D
onready var turret: Node2D = get_parent().ke_turret # This is supposed the base of the turret node
onready var world: Node2D = turret.world

func get_distance_to(target_arg: Node):
	# angle divide speed
	# var target_velocity: Vector2 = target_arg.velocity
	var distance: float = (target_arg.position - global_position).length()
	return distance

func get_offset(dir: Vector2, target_speed: int, distance: float):
	# (bullet speed - target speed / distance) * direction
	var speed_diff: float = bullet_speed - target_speed
	var offset_ = ((dir * distance)/target_speed) * (bullet_speed * get_physics_process_delta_time())
	return offset_

func fire():
	var bullet: Node = BulletScene.instance()
	if !turret.inverted:
		bullet.initialize(nozzlePos.global_position, rotation,
				damage, bullet_speed, range_, Globals.PLAYER_MB)
	else:
		bullet.initialize(nozzlePos.global_position, deg2rad(rotation_degrees + 180),
				damage, bullet_speed, range_, Globals.PLAYER_MB)
	world.add_child(bullet)
	Globals.play_audio(nozzlePos.global_position, Globals.GUN_SHOT_1)

func _physics_process(delta):
	if target:
		# get_parent().get_node("RayCast2D").look_at(target.position)
		look_at(target.global_position + get_offset(target.velocity.normalized(),
			target.speed,get_distance_to(target)))
		# set_rotation($RayCast2D.rotation)
		if can_shoot:
			fire()
			animation.play("gunfire")
			can_shoot = false
			if $firerate.is_stopped():
				$firerate.start()

func _ready():
	get_parent().nozzle = self
	if turret.inverted:
		rotation_degrees = 180

func _on_firerate_timeout():
	can_shoot = true
