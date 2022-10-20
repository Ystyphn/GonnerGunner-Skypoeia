class_name LandingGearClass
extends CollisionPolygon2D

export (int) var destination_pos = 26
export (NodePath) var sprite_path
export (NodePath) var animation_player_path

var real_position
var original_position: Vector2
var deployed: bool

onready var sprite = get_node(sprite_path)
onready var animation_player = get_node(animation_player_path)

func _ready():
	get_original_position()
	
	# Now the real positoin will never change its value anymore
	real_position = get_position()

func face_to(direction: String):
	direction = direction.to_lower()
	if direction == "left":
		scale.x = -1
		var pos_x = real_position.x * -1
		position.x = pos_x
	elif direction == "right":
		scale.x = abs(scale.x)
		var pos_x = real_position.x
		position.x = pos_x
	else:
		print("Unrecognized direction ", direction)

func get_original_position():
	# This will return the position in the parent
	original_position = get_position()
	return original_position

func raise():
	# This will raise the landing gear and disable the collision
	# The landing gear's position should return to the original
	$AnimationPlayer.play("raise")
	$Tween.interpolate_property(self, "position:y", get_position().y,
	original_position.y, 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()
	deployed = false

func deploy():
	# Tis will deploy the landing gear
	# Drop the landing gear from original position to deployed position
	$AnimationPlayer.play("deploy")
	$Tween.interpolate_property(self, "position:y", original_position.y,
	original_position.y + destination_pos, 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()
	deployed = true
