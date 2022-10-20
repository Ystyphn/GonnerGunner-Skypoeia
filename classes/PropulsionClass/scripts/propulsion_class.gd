"""
The particles of the propulsion must be proportion to the engine's power output

So technically speaking, if the engine's power output is at 50%, the length of
the propulsion_particle_lifetime will also be of 50% max_lifetime, so first
get the 50% of the maximum lifetime and apply that value to the actual lifetime of
the particle, this logic is also similar to the light texture
"""
class_name PropulsionClass
extends StaticBody2D

export (float) var propulsion_particle_lifetime = 1
export (float) var min_lifetime = 0.25
export (float) var max_lifetime = 2.0
export (float) var max_light_texture_scale = 2.0

var current_engine_output

onready var light: Light2D = get_node("Light2D")
onready var propulsion_particles: Particles2D = get_node("PropulsionParticles")
onready var propulsion_sprite: Sprite = get_node("PropulsionSprite")


func set_engine_output(engine_output):
	# This must get the percentage of the engine output
	current_engine_output = engine_output
	var particle_lifetime = MyMath.get_percent_of(max_lifetime, engine_output)
	particle_lifetime = max(0.1, particle_lifetime)
	var light_texture_scale: float = MyMath.get_percent_of(max_light_texture_scale,
			engine_output)
	$PropulsionParticles.set_lifetime(particle_lifetime)
	$Light2D.set_texture_scale(light_texture_scale)

func set_state(new_state: String):
	$StateMachine.transition_to(new_state)
	
func get_state():
	return $StateMachine.get_state()
