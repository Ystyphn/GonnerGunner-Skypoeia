extends DoorState


func enter(msg:={}):
	door.sprite.set_frame(1)
	door.set_collision_layer_bit(3, false)
