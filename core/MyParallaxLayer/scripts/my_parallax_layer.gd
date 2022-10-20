extends ParallaxLayer

export (Vector2) var fixed_position = Vector2.ZERO

func _ready():
	position = fixed_position
