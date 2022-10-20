extends PropulsionState


func enter(msg:={}) -> void:
	propulsion.propulsion_particles.set_emitting(true)
