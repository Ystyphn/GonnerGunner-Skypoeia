extends Node2D


var direction: Vector2
var drag_velocity: int = 400
var flying: bool 
var hooked: bool
var hook_loc: Vector2
var max_reached: bool = false
var shoot_speed: int = 400
var range_: int = 150
var tip: Vector2

onready var chains: Sprite = $Chains
onready var entity: Node = get_parent()
onready var hook: Node = $Hook

func shoot(dir: Vector2): # The expected direction is a global_coordinate
	direction = dir.normalized()
	flying = true
	tip = self.global_position

func release():
	if entity.current_state != entity.MOUNTING:
		entity.current_state = entity.FREE
	entity.colliding = false
	hooked = false
	flying = false
	#max_reached = false
	#shoot_speed = abs(shoot_speed)

func _process(delta):
	set_visible(flying || hooked)
	if not visible:
		return
	hook_loc = to_local(tip)
	chains.rotation = position.angle_to_point(hook_loc) - deg2rad(90)
	$Hook.rotation = position.angle_to_point(hook_loc) - deg2rad(90)
	chains.position = hook_loc
	chains.region_rect.size.y = hook_loc.length()
	if hook_loc.length() >= range_:
		release()
		#max_reached = true
		#shoot_speed = -shoot_speed

func _physics_process(delta: float):
	$Hook.global_position = tip
	if flying:
		if $Hook.move_and_collide((direction * shoot_speed)*delta):
			entity.current_state = entity.GRAPPLED
			entity.set_grappled($Hook.global_position,drag_velocity)
			hooked = true
			entity.can_jump = true
			flying = false
	tip = $Hook.global_position

func _unhandled_input(event):
	if event.is_action_pressed("grapple"):
		if entity.current_state != entity.MOUNTING:
			if !flying && !hooked:
				shoot(get_local_mouse_position())
			elif flying || hooked:
				release()
