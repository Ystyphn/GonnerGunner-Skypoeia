extends KinematicBody2D


var NozzleScene: PackedScene = preload("res://src/objects/ship_equipments/turrets/nozzles/MG_Nozzle_T1.tscn")
var Explosion: PackedScene = preload("res://src/objects/effects/explosions/scenes/bomb_explosion_small.tscn")

var max_health: int = 750
var health: int = max_health
var inverted: bool = false
var target: Node2D = null
var targets: Array

onready var nozzle: Node2D = null
onready var world: Node2D = get_parent().get_parent().get_parent()

func add_health(val: int):
	health += val
	get_parent().update_health(health)

func apply_damage(damage: int):
	health -= damage
	get_parent().update_health(health)

func update_animation(frame: int):
	$Sprite.set_frame(frame)
	$Nozzle.nozzle.get_node("Sprite").set_frame(frame)

func _process(delta) -> void:
	if !target:
		if targets.size() > 0:
			target = targets[0]
			$Nozzle.set_target(target) # give target to the nozzle
	if health <= 0:
		if !get_parent().broken:
			health = 0
			$Nozzle.nozzle.set_physics_process(false)
			get_parent().broken = true
			update_animation(2)
			$Particles2D.set_emitting(true)
	else:
		if $Particles2D.emitting:
			$Particles2D.set_emitting(false)
		get_parent().broken = false
		# update_animation(0)
		$Nozzle.nozzle.set_physics_process(true)

func _on_DetectionArea_body_entered(body):
	# This won't care about bodies that aren't hostiles
	if body.get_collision_layer() == Globals.ENEMY_LAYER:
		if not body in targets:
			targets.append(body)

func _on_DetectionArea_body_exited(body):
	if body in targets:
		# Remove the target to the nozzle and this turret
		targets.erase(body)
		target = null
		$Nozzle.remove_target()

func _ready():
	var nozzle: Node2D = NozzleScene.instance()
	nozzle.position = Vector2.ZERO
	$Nozzle.add_child(nozzle)
	if round(rotation_degrees) == 180:
		inverted = true
		$Particles2D.scale *= -1
