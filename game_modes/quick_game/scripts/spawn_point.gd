extends Position2D


var current_count: int = 0 # How many objects are spawned in current session
var entity: Node = null
var max_count: int = 0
var spawning: bool = false
var payload: Node

func spawn(entity_: Node, payload: Node = null):
	if !payload:
		entity_.position = position
		get_parent().add_child(entity_)
	else:
		entity_.position = position
		Globals.set_payload_of(entity_, payload)
		get_parent().add_child(entity_)

func start_spawn(entity_: Node, max_count: int, payload: Node =null):
	# This will be the method to spawn groups of enemies
	entity = entity_
	self.max_count = max_count
	if !spawning:
		spawning = true
		if $SpawnDelay.is_stopped():
			$SpawnDelay.start()
	else:
		return false
	payload = payload

func _on_SpawnDelay_timeout():
	if current_count < max_count:
		if !payload:
			entity.position = position
			get_parent().add_child(entity)
			current_count += 1
		else:
			entity.position = position
			get_parent().add_child(entity)
			current_count += 1
			Globals.set_payload_of(entity, payload)
	else:
		$SpawnDelay.stop()
		current_count = 0
		payload = null
