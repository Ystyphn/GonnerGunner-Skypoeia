extends Node2D

const ENTITIES: Array = [
	preload("res://src/entities/scenes/round_copter/round_copter.tscn"),
	preload("res://src/entities/scenes/deployer_drone/Deployer_Drone.tscn")
]

const PAYLOAD: Array = [
	preload("res://src/entities/scenes/walking_mine/WalkingMine.tscn"),
	preload("res://src/objects/missiles/scenes/RO-01.tscn")
]

export (int) var right_limit = 0
export (int) var left_limit = 0
export (int) var bottom_limit = 0
export (int) var top_limit = 0

var current_score: int = 0
var player: Node
var ship: Node
var wave: int = 1
var wave_ongoing: bool = false
var groups: int = 0
var enemy_increment: int = 5 # The increase in enemies
var max_enemies: int = 10
var enemy_queue: int = max_enemies # How many enemies were left
# The 2 below explains its purpose
var spawn_limit: int  = 10
var total_spawned_enemies: int

func choose_enemy():
	var index: int = randi() % 2
	return ENTITIES[index].instance()

func choose_payload():
	var index: int = randi() % 2
	return PAYLOAD[index].instance()

func spawn_to(index: int):
	var enemy_object: Node = choose_enemy()
	var spawner_str: String = "SpawnPoint_"+str(index+1)
	var spawner: Node = get_node(spawner_str)
	if enemy_object.type == "carrier":
		spawner.spawn(enemy_object, PAYLOAD[1].instance())
		#get_node(spawner).spawn(enemy_object, payload)
	else:
		#get_node(spawner.name).spawn(enemy_object)
		spawner.spawn(enemy_object)
	enemy_queue -= 1

func update_points(value: int):
	current_score += value
	PlayerUi.update_score(current_score)

func update_volume():
	pass

func update_wave():
	max_enemies += enemy_increment
	enemy_queue = max_enemies
	wave += 1
	spawn_limit += 1
	total_spawned_enemies = 0 # Make sure to reset total spawned enemies
	wave_ongoing = false
	if $WaveDelay.is_stopped():
		$WaveDelay.start()
		Notifier.get_node("Control").set_visible(true)

func _process(delta):
	$AudioStreamPlayer.set_volume_db(Globals.Math.decimalize(Globals.sfx_volume))

func _physics_process(delta):
	if !Globals.player_dead:
		if wave_ongoing:
			if enemy_queue > 0:
				if total_spawned_enemies < spawn_limit:
					if $SpawnRate.is_stopped():
						$SpawnRate.start()
				else:
					if !$SpawnRate.is_stopped():
						$SpawnRate.stop()
			else:
				if !$SpawnRate.is_stopped():
					$SpawnRate.stop()
			if total_spawned_enemies <= 0 && enemy_queue <= 0:
				update_wave()

func _ready():
	randomize()
	Globals.set_ingame(true)
	Globals.player_dead = false
	FadeCover.get_node("AnimationPlayer").play("fade_out")
	player = $Player
	get_tree().call_group("enemies","activate")
	wave_ongoing = true
	PlayerUi.update_wave(wave)

func _on_SpawnRate_timeout():
	var spawner_index: int
	if ship.position.y > -390:
		spawner_index = randi() % 4
	elif ship.position.y < -390:
		spawner_index = (randi() % 4) + 4
	spawn_to(spawner_index)
	total_spawned_enemies +=1

func _on_WaveDelay_timeout():
	if !wave_ongoing:
		wave_ongoing = true
		PlayerUi.update_wave(wave)
		Notifier.get_node("Control").set_visible(false)

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
