extends AudioStreamPlayer2D

func setup(pos: Vector2, audio: AudioStream):
	global_position = pos
	set_stream(audio)

func finished():
	queue_free()

func _ready():
	set_bus("SFX")
	play()

func _process(delta):
	set_volume_db(Globals.Math.decimalize(Globals.sfx_volume))
