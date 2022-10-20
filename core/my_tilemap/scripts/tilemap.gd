extends TileMap


func get_neighbors(pos: Vector2, eight_sides: bool = true):
	# if the eight_sides paramter is set to true, it will return the sides on
	# coordinates nw, n, ne, w, e, sw, s, se
	# else it will only return n, w, e, s
	var coordinates: Array = []
	if eight_sides:
		for y in range(pos.y - 1, pos.y + 2):
			for x in range(pos.x - 1, pos.x +2):
				if Vector2(x,y) == pos:
						continue
				coordinates.append(Vector2(x,y))
		return coordinates
	else:
		print("Disabled 8 tiles in unsupported yet")


func get_neighbor_values(pos: Vector2):
	# This method will return the values that exists on the sides of the
	# specified coordinates.
	var values: Array = []
	#var counter_y: int = 0
	#var coutner_x: int = 0
	for y in range(pos.y - 1, pos.y + 2):
		for x in range(pos.x - 1, pos.x + 2):
			if Vector2(x,y) == pos:
				continue
			if get_cell(x,y) != -1:
				values.append(1)
			else:
				values.append(0)
	
	return values
			
