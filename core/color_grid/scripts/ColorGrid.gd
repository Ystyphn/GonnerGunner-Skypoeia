"""
TAKE NOTE:
	When talking about intensities, 255 is transparent and 0 is opaque
"""

class_name ColorGrid
extends Node

export (NodePath) var light_sprite_path

var red_values: Array # This will contain all the red values each tiles (if it has)
var blue_values: Array # This will contain all the blue values of each tiles
var green_values: Array # This will contain all the green values of each tiles
var intensities: Array # This corresponds to alpha values

onready var light_sprite: = get_node(light_sprite_path)

func _ready():
	pass

func init_color_values(size: Vector2 = Vector2.ZERO):
	# This will be called by the light sprite for initializations of the 
	# color values. I think this wont be necessary anymore.
	pass

func calculate_colors(size: Vector2):
	var intensity_img: Image = Image.new()
	var intensity_img_texture: ImageTexture = ImageTexture.new()
	
	intensity_img.create_from_data(size.x, size.y, false, Image.FORMAT_L8,
			intensities)
	
	intensity_img_texture.create_from_image(intensity_img)
	light_sprite.material.set_shader_param("intensity_texture", 
			intensity_img_texture)

func reset_color_values():
	intensities.clear()
