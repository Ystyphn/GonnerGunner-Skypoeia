extends DoorState


func enter(msg:={}):
	door.sprite.set_frame(0)
	door.set_collision_layer_bit(3, true)
