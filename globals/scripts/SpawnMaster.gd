extends Node

enum {
	SINGLE,
	PARADE
}

var current_game: Node
var spawn_delay: Timer = Timer.new()

func quick_game_spawner(game_node: Node, object: Node,
		spawner: Node, spawn_mode: Array, payload_: Node = null):
	if spawn_mode[0] == SINGLE:
		if object.name_ == "RoundCopter":
			object.position = spawner.position
			game_node.add_child(object)
		elif object.name == "DeployerDrone":
			object.position = spawner.position
			Globals.set_payload_of(object, payload_)
			game_node.add_child(object)
	elif spawn_mode[0] == PARADE:
		if object.name_ == "RoundCopter":
			spawner.start_spawn(object,spawn_mode[1])
		elif object.name == "DeployerDrone":
			spawner.start_spawn(object,spawn_mode[1],payload_)

func _ready():
	spawn_delay.set_one_shot(true)
	spawn_delay.set_wait_time(0.75)
	spawn_delay.start()
