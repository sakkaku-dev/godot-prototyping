# https://abitawake.com/news/articles/procedural-generation-with-godot-creating-caves-with-cellular-automata
@tool
class_name CellularAutomataDungeon
extends TileMapTool

@export var map_w         = 80
@export var map_h         = 50
@export var iterations    = 20000
@export var neighbors     = 4
@export var ground_chance = 48
@export var min_cave_size = 80

@export var wall_layer = 1
@export var wall_source = 1
@export var wall_terrain_set = 0
@export var wall_terrain_id = 0

@export var floor_layer = 0
@export var floor_source = 1
@export var floor_tile := Vector2i(10, 1)

var caves = []

func get_lowest_position():
	var lowest = null
	
	for cave in caves:
		for v in cave:
			if lowest == null:
				lowest = v
				continue
			
			if v.x < lowest.x or v.y > lowest.y:
				lowest = v
	
	return map_to_local(lowest)

func do_run():
	generate()

func get_rooms():
	return caves.duplicate(true)

func generate():
	clear()
	fill_roof()
	random_ground()
	dig_caves()
	get_caves()
	connect_caves()
	
	var walls = get_used_cells(wall_layer)
	set_cells_terrain_connect(wall_layer, walls, wall_terrain_set, wall_terrain_id)

func fill_roof():
	print("Filling caves")
	var cells = []
	for x in range(map_w):
		for y in range(map_h):
			cells.append(Vector2i(x, y))

	set_cells_terrain_connect(wall_layer, cells, wall_terrain_set, wall_terrain_id)

func random_ground():
	for x in range(1, map_w - 1):
		for y in range(1, map_h - 1):
			if randi() % 100 < ground_chance:
				_set_floor(Vector2i(x, y))

func dig_caves():
	print("Digging caves")
	for i in range(iterations):
		var x = floor(randi_range(1, map_w - 1))
		var y = floor(randi_range(1, map_h - 1))
		var p = Vector2i(x, y)

		var nearby_floors = check_nearby_floors(x, y)
		if nearby_floors > neighbors:
			_set_floor(p)
		elif nearby_floors < neighbors:
			_set_wall(p)

func check_nearby_floors(x, y):
	var center = Vector2i(x, y)
	var dirs = [
		Vector2i.RIGHT,
		Vector2i.LEFT,
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i(1, 1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
		Vector2i(-1, -1)
	]

	return dirs.filter(func(v): return _is_floor(center + v)).size()

func _set_wall(v: Vector2i):
	set_cell(wall_layer, v, wall_source, Vector2.ZERO)
	erase_cell(floor_layer, v)

func _set_floor(v: Vector2i):
	set_cell(floor_layer, v, floor_source, floor_tile)
	erase_cell(wall_layer, v)

func _is_floor(v: Vector2i):
	return get_cell_source_id(floor_layer, v) != -1
	
func _is_wall(v: Vector2i):
	return get_cell_source_id(wall_layer, v) != -1

func get_caves():
	caves = []

	print("Getting caves")
	for x in range(map_w):
		for y in range(map_h):
			if _is_floor(Vector2i(x, y)):
				flood_fill(x, y)
	
	for cave in caves:
		for tile in cave:
			_set_floor(tile)

func flood_fill(x, y):
	var cave = []
	var to_fill = [Vector2(x, y)]
	while to_fill:
		var tile = to_fill.pop_back()
		
		if not tile in cave:
			cave.append(tile)
			_set_wall(tile)

			var north = Vector2(tile.x, tile.y - 1)
			var south = Vector2(tile.x, tile.y + 1)
			var east = Vector2(tile.x + 1, tile.y)
			var west = Vector2(tile.x - 1, tile.y)

			for dir in [north, south, east, west]:
				if _is_floor(dir):
					if not dir in to_fill and not dir in cave:
						to_fill.append(dir)

	if cave.size() >= min_cave_size:
		caves.append(cave)

func connect_caves():
	print("Connecting caves")
	var prev_cave = null
	var tunnel_caves = caves.duplicate()

	for cave in tunnel_caves:
		if prev_cave:
			var new_point = cave.pick_random()
			var prev_point = prev_cave.pick_random()

			if new_point != prev_point:
				create_tunnel(new_point, prev_point, cave)
		
		prev_cave = cave

func create_tunnel(point1, point2, cave):
	var max_steps = 500
	var steps = 0
	var drunk_x = point2.x
	var drunk_y = point2.y

	while steps < max_steps and not Vector2(drunk_x, drunk_y) in cave:
		steps += 1

		var n = 1.0
		var s = 1.0
		var e = 1.0
		var w = 1.0
		var weight = 1

		if drunk_x < point1.x:
			e += weight
		elif drunk_x > point1.x:
			w += weight
		
		if drunk_y < point1.y:
			s += weight
		elif drunk_y > point1.y:
			n += weight

		var total = n + s + e + w
		n /= total
		s /= total
		e /= total
		w /= total

		var dx
		var dy

		var choice = randf()

		if 0 <= choice and choice < n:
			dx = 0
			dy = -1
		elif n <= choice and choice < n + s:
			dx = 0
			dy = 1
		elif n + s <= choice and choice < n + s + e:
			dx = 1
			dy = 0
		else:
			dx = -1
			dy = 0
		
		# ensure not to walk past edge of map
		if (2 < drunk_x + dx and drunk_x + dx < map_w - 2) and (2 < drunk_y + dy and drunk_y + dy < map_h - 2):
			drunk_x += dx
			drunk_y += dy
			if _is_wall(Vector2i(drunk_x, drunk_y)): #get_cell_source_id(layer, Vector2i(drunk_x, drunk_y)) == wall_source:
				_set_floor(Vector2i(drunk_x, drunk_y))

				# optional: make the tunnel wider
				_set_floor(Vector2i(drunk_x + 1, drunk_y))
				_set_floor(Vector2i(drunk_x + 1, drunk_y + 1))


