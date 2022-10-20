extends Sprite

export (Vector2) var fixed_position = Vector2.ZERO

func _ready():
	set_position(fixed_position)
