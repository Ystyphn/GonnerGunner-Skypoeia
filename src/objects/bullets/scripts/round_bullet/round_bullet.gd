extends Area2D

export (int) var speed = 80

var damage: int = 0
var init_pos: Vector2 # this is the initial position of the bullet to determine the range
var max_range: int
var velocity: Vector2

func initialize(pos: Vector2, angle: float ,dmg: int, 
		speed: int = 100, _range: int = 150, mask_: int = Globals.ALL_MB):
	global_position = pos
	init_pos = pos
	velocity.x = cos(angle) * speed
	velocity.y = sin(angle) * speed
	damage = dmg
	speed = speed
	max_range = _range
	# set_collision_mask(mask_)

func _physics_process(delta):
	global_position += velocity * delta
	if(position - init_pos).length() > max_range:
		velocity = Vector2.ZERO
		$Sprite/AnimationPlayer.play("collide")

func _ready():
	$Sprite/AnimationPlayer.play("fly")

func _on_round_bullet_body_entered(body):
	velocity = Vector2.ZERO
	monitoring = false
	if body.name != "TileMap" && body.name != "trapdoor_1":
		body.apply_damage(damage)
	$Sprite/AnimationPlayer.play("collide")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collide":
		queue_free()

