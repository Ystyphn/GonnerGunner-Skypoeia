class_name ShipClass
extends KinematicBody2D


export (int) var health = 4000
export (int) var armor_health = 1200

export (float) var damage_reduction = 0.25
export (float) var maneuver_speed = 25.0 # The speed moving up and down
export (float) var top_speed = 65.0
export (float) var acceleration = 50.0
export (float) var friction = 0.1
export (float, 0.0, 1.0) var tilt_speed = 0.15

export (Dictionary) var top_turrets_paths
export (Dictionary) var bottom_turrets_paths
export (Dictionary) var landing_gears

export (NodePath) var animation_player_path
export (NodePath) var state_machine_path

var speed: float = 0.0
var engine_output: float = 0.0
var target_speed: float = 0.0 # This will be the target speed the ship will reach
var velocity: Vector2
var landing_gear_deployed: bool
var passengers: Array
var flipped: bool = false # False means facing right
var landed: bool = true

onready var collision_polygon = get_node("CollisionPolygon2D")
onready var body: Node2D = get_node("Body")
onready var propulsions: PropulsionNode = get_node("Body/Propulsions")

func _physics_process(delta):
	if passengers.size() == 0:
		return
	for passenger in passengers:
		passenger.ship_relative_position = body.to_local(passenger.get_global_position())

func increase_engine_output():
	engine_output += 1
	engine_output = clamp(engine_output, 0.0, 100.0)
	target_speed = MyMath.get_percent_of(top_speed, engine_output)
	propulsions.set_engine_output(engine_output)

func decrease_engine_output():
	engine_output -= 1
	engine_output = clamp(engine_output, 0.0, 100.0)
	target_speed = MyMath.get_percent_of(top_speed, engine_output)
	propulsions.set_engine_output(engine_output)

func set_animation(anim: String) -> void:
	get_node(animation_player_path).play(anim)
	return

func manage_tilt():
	# This will manage the tilting of the ship depends on where the ship is facing
	if is_on_floor():
		landed = true
		velocity.y = 0
	if !flipped:
		if velocity.y != 0:
			if is_on_floor():
				print("On floor something strange")
			# Simply means the ship is not travelling straight
			var target_angle = -5 if velocity.y < 0 else 5
			rotation_degrees = lerp(rotation_degrees, target_angle,
					tilt_speed)
		else:
			# Means the ship is travelling straight
			rotation_degrees = lerp(rotation_degrees, 0.0, tilt_speed)
	else:
		if velocity.y != 0:
			# Simply means the ship is not travelling straight
			var target_angle = 5 if velocity.y < 0 else -5
			rotation_degrees = lerp(rotation_degrees, target_angle,
					tilt_speed)
		else:
			# Means the ship is travelling straight
			rotation_degrees = lerp(rotation_degrees, 0.0, tilt_speed)

func toggle_engine():
	if get_state() == "Landed" or get_state() == "OnAir":
		set_state("Active")
		return
	elif get_state() == "Active":
		if is_on_floor():
			set_state("Landed")
		else:
			set_state("OnAir")

func face_to(direction: String):
	# Responsible for passenger repositioning
	direction.to_lower()
	if direction == "left":
		body.scale.x = -1
		collision_polygon.scale.x = -1
		flipped = true
	elif direction == "right":
		body.scale.x = 1
		collision_polygon.scale.x = 1
		flipped = false
	for landing_gear in landing_gears:
		get_node(landing_gears[landing_gear]).face_to(direction)
	for passenger in passengers:
		passenger.reposition(self.body)

func deploy_landing_gear():
	if landing_gears.size() == 0:
		return
	for landing_gear in landing_gears:
		get_node(landing_gear).deploy()
	landing_gear_deployed = true

func raise_landing_gear():
	if landing_gears.size() == 0:
		return
	for landing_gear in landing_gears:
		get_node(landing_gear).raise()
	landing_gear_deployed = false

func get_direction():
	# This will return where the ship is facing either left or right
	return body.scale.x

func set_state(new_state: String):
	$StateMachine.transition_to(new_state)

func get_state():
	return $StateMachine.get_state()

func apply_damage(damage: Dictionary):
	pass

func body_entered(body):
	pass

func body_exited(body):
	pass

func add_passenger(body):
	pass
	
func remove_passenger(body):
	pass
