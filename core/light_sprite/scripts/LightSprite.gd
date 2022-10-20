"""
General Idea Making Tile Lightings:
	1. Make Grids of tiles that will determine what are the lightsource and not
	2. Make those grids of colors to textures
	3. Render them in the sprite shade
	4. Optimize them
	
light_tiles array structure
	
	array_x[array_y[value],...]
	where:
		array_x = contains array of y coordinates
		array_y = contains array of light_tiles in the specific coordinates
	
	example:
		light_tiles = [[1,0,0,0,0,1,1,1,1],
						[1,0,1,1,1,1,1,1,1]]

Goal 1:
	Make the tiles look like shadows
	Steps:
		1. Get all occupied and unoccupied cells 
		
		2. The occupied cells must be a shadow while the unoccupied is not a shadow and
		leave it be
"""
extends Sprite

const RED_LIGHT = [255,153,153]
const ORANGE_LIGHT = [255,205,126]
const BLUE_LIGHT = [126,135,255]
const GREEN_LIGHT = [126,255,128]
const AMBIENT_LIGHT = [255,255,255]
const NO_LIGHT = [0,0,0]

export (int) var extension_units = 10
export (NodePath) var tilemap_path

var light_range: int = 4

var tile_values: Array = [] # This will contain 1 or 0
var color_values: Array = [] # You will initialize these two first

var color_array: Array = [] # Unlike color values, this array will only
# contain 1 dimension just to convert it to image

var size: Vector2
var snap_step = 128
var size_in_tiles: Vector2 # Determines how many tiles does this sprite occup-
# ies
var tilesize: int = 8

var thread: Thread = Thread.new()
var semaphore: Semaphore = Semaphore.new()
var thread_finished: bool = false

var normal_drop_off: float = 0.6
var tile_drop_off: float = 0.9


onready var tilemap: TileMap = get_node(tilemap_path)


func _ready():
	yield(get_parent(), "ready")
	set_size()
	thread.start(self, "_solve_light_thread")

func _process(delta):
	#set_pos()
	pass

func intensity_dropoff(color: Array, drop_off, layer):
	# This will return new color value that is already intesified
	# Where:
	# 	layer = distance from the source
	# 	drop_off = is the constant diminishing
	var new_color: Array = []
	var channel_var: float
	
	for channel in color:
		channel_var = channel * pow(drop_off, layer)
		new_color.append(channel_var)
	
	return new_color

func is_initialized():
	return color_values.size() > 0 and tile_values.size() > 0

func initialize():
	# This might be called upon camera zoom in or zoom out
	# Also might be called by resize() or set_size() method
	
	# Make sure color array and tile_values array are empty
	color_values.clear()
	tile_values.clear()
	
	for y in range(size_in_tiles.y):
		tile_values.append([])
		color_values.append([])
		for x in range(size_in_tiles.x):
			tile_values[y].append(false)
			color_values[y].append([]) # Contain rgb arrays 

func make_color_from_array(array: Array):
	# This will make a color from the array 
	return Color(array[0], array[1], array[2], array[3])

func is_sky(pos):
	# check if there are no blocks that surrounds it
	for ny in range(pos.y - 1, pos.y + 2):
		for nx in range(pos.x - 1, pos.x +2):
			if !inside_image_bounds(Vector2(nx,ny)):
				continue
			if Vector2(nx, ny) == pos:
				continue
			if !get_light(Vector2(nx,ny))[0]:
				# Means the current point is a tile
				return false
			else:
				# This means the current point is a sky
				continue
	return true

func get_neighborsv(pos: Vector2, use_8_neighbors = false):
	if !use_8_neighbors:
		# Means use 4 neighboring system
		var neighbors: Array =[
			Vector2(pos.x, pos.y - 1),
			Vector2(pos.x + 1, pos.y),
			Vector2(pos.x - 1, pos.y),
			Vector2(pos.x, pos.y + 1)
		]
		return neighbors
		

func inside_image_bounds(pos: Vector2):
	return pos.x >= 0 and pos.x < size_in_tiles.x and \
			pos.y >= 0 and pos.y < size_in_tiles.y

func on_range(pos: Vector2, min_range: Vector2, max_range: Vector2):
	return pos.x >= min_range.x and pos.x <= max_range.x \
			and pos.y >= min_range.y and pos.y <= max_range.y

func make_image():
	# This will return an image based on the color array
	var image: Image = Image.new()
	
	color_array.clear()
	for y in color_values:
		for x in y:
			color_array.append_array(x)
	image.create_from_data(size_in_tiles.x, size_in_tiles.y, false,
			4, color_array)
	image.save_png("test.png")
	return image

func _solve_light_thread(data):
	#while true:
	#	semaphore.wait()
		
		#if thread_finished:
		#	break
		
	# 255 is the light and 0 is the tile
	var start_x: = int(get_global_position().x / tilesize)
	var start_y: = int(get_global_position().y / tilesize)
		
		
		

func set_pos():
	var pos_x = stepify(Globals.player.global_position.x, snap_step)
	var pos_y = stepify(Globals.player.global_position.y, snap_step)
	
	if Vector2(pos_x, pos_y) != get_global_position():
		set_global_position(Vector2(pos_x - size.x/2, pos_y - size.y/2))
		if is_initialized():
			#_solve_light_thread(null)
			solve_light()

func light_changed(idx: Vector2):
	# This will check if the specified tile is changed or not
	var tile_color: Array = get_light(idx)[1]
	if tile_color == AMBIENT_LIGHT or tile_color == NO_LIGHT:
		return false
	else:
		return true

func get_light(idx: Vector2):
	# Return the light value and the color value
	if !inside_image_bounds(idx):
		return
	return [tile_values[idx.y][idx.x], color_values[idx.y][idx.x]]

func solve_light():
	semaphore.post()

func set_light(switch: bool, idx: Vector2):
	# This will set light switches to the grid
	if !inside_image_bounds(idx):
		return
	tile_values[idx.y][idx.x] = switch

func set_color(color: Array, idx: Vector2):
	# This will set the color of a light in the grid
	# Note: Event though a there are color of tile on the tile grid, 
	# it might not still emit light
	# This method expect an array and not a Color class
	if !inside_image_bounds(idx):
		return
	color_values[idx.y][idx.x] = color

func set_size():
	# This will also reinitialize the color_values and tile_values
	size = get_viewport().size + Vector2(tilesize * extension_units,
			tilesize * extension_units)
	var cam: Camera2D = Globals.player.camera
	size *= cam.zoom
	size.x = stepify(size.x, tilesize * 4)
	size.y = stepify(size.y, tilesize * 4)
	
	size_in_tiles.x = int(size.x/tilesize)
	size_in_tiles.y = int(size.y/tilesize)
	
	set_scale(size)
	initialize()

func _exit_tree():
	thread.wait_to_finish()
	thread_finished = true
	semaphore.post()
