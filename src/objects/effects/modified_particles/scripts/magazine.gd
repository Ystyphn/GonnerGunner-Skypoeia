extends RigidBody2D


func _ready():
	set_bounce(rand_range(0.35, 0.55))

func _on_lifetime_timeout():
	queue_free()
