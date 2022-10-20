extends Area2D


export (int) var damage = 10 # This will be added to the weapon's damage

export (float) var pierce = 0.1 # This will be added to the weapon's pierce 

export (PackedScene) var crash_effect

var total_damage
var total_pierce

var crit_chance
var angle
var speed
var starting_point: Vector2 # This will be the starting position of this 
# bullet
var max_range
var velocity: Vector2

func _ready():
	set_global_position(starting_point)
	connect("body_entered", self, "body_entered")

func initialize(data: Dictionary) -> void:
	# Initialize datas passed by the gun
	total_damage = data["damage"] + damage
	total_pierce = data["pierce"] + pierce
	speed = data["speed"]
	starting_point = data["pos"]
	max_range = data["max_range"]
	angle = data["angle"]
	crit_chance = data["crit_chance"]
	set_global_rotation(angle)

func _physics_process(delta):
	var x_vel = cos(angle)
	var y_vel = sin(angle)
	
	velocity = Vector2(x_vel, y_vel) * speed
	position += velocity * delta
	
	if (get_global_position() - starting_point).length() >= max_range:
		queue_free()

func body_entered(body):
	if !body.has_method("apply_damage"):
		var bullet_crash_effect = crash_effect.instance()
		bullet_crash_effect.set_global_position(get_global_position())
		Globals.game_scene.effects_node.add_child(bullet_crash_effect)
		queue_free()
		return
	body.apply_damage({"damage": total_damage, "pierce": total_pierce})
	queue_free()
	return
