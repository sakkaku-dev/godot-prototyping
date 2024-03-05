class_name InfiniteMap
extends TileMap

@export var layer := 0
@export var center_node: Node2D
@export var source_id := 3

var grid_dividor := 3
var tile_size_on_grid: Vector2i
var tile_center: Vector2i

var _current_center_offset = Vector2i.ZERO

# For Debugging
var tile_pos
var grid_pos
var grid_dir

func _ready():
	clear()
	for x in range(4):
		for y in range(4):
			print(x, "-", y)
			set_cell(layer, Vector2i(x, y), source_id, Vector2i.ZERO)
	
	var rect = get_used_rect()
	
	tile_size_on_grid = rect.size / grid_dividor
	tile_center = rect.position + tile_size_on_grid
	
	print("Tilemap Rect: %s" % rect)
	print("Tile Size: %s, Tile Center: %s" % [tile_size_on_grid, tile_center])
	
	var x_remainder = rect.size.x % grid_dividor
	var y_remainder = rect.size.y % grid_dividor 
	if x_remainder != 0 or y_remainder != 0:
		print("TileMap size is not divisible by %s. Unexpected behaviour might occur" % grid_dividor)
		print("Remove %s tiles from the X-axis and %s tiles from the Y-axis" % [x_remainder, y_remainder])

func _process(delta):
	if center_node:
		update_for_position(center_node.global_position)

func get_center_position():
	return map_to_local(tile_center + tile_size_on_grid / 2)

func update_for_position(pos: Vector2):
	tile_pos = local_to_map(pos)
	grid_pos = _tile_to_grid(tile_pos)

	grid_dir = grid_pos - _current_center_offset
	var is_outside_grid = grid_dir.length() > 0

	if is_outside_grid:
		print("Tile Position %s in grid %s moving in %s" % [tile_pos, grid_pos, grid_dir])

		for neighbor_dir in _get_grid_dirs_to_fill(grid_dir):
			var target_grid = grid_pos + neighbor_dir
			var source_grid = target_grid - grid_dir * Vector2i(grid_dividor, grid_dividor)
			_cut_grid_tiles(source_grid, target_grid)

		_current_center_offset = grid_pos
		

func _get_grid_dirs_to_fill(grid_dir: Vector2i):
	var neighbors = [
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i(1, 1),
		Vector2i(-1, -1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
	]

	var result = []
	for n in neighbors:
		var dot = Vector2(grid_dir).dot(n)
		var is_straight = int(rad_to_deg(Vector2(grid_dir).angle())) % 90 == 0

		if dot > 0 or (not is_straight and dot == 0):
			result.append(n)

	return result


func _cut_grid_tiles(source_grid: Vector2i, target_grid: Vector2i):
	var source_top_left = _grid_to_tile(source_grid)
	var target_top_left = _grid_to_tile(target_grid)

	for x in range(0, tile_size_on_grid.x):
		for y in range(0, tile_size_on_grid.y):
			var offset = Vector2i(x, y)
			var source_cell = source_top_left + offset
			var target_cell = target_top_left + offset

			# Currently there can be a bug when copying the cells from the source
			# For now used fixed atlas coordinate
			#var source_id = get_cell_source_id(layer, source_cell)
			#var atlas = get_cell_atlas_coords(layer, source_cell)
			set_cell(layer, target_cell, source_id, Vector2.ZERO)
			#erase_cell(layer, source_cell)


func _grid_to_tile(grid_pos: Vector2i):
	var pos = Vector2i(
		tile_size_on_grid.x * grid_pos.x,
		tile_size_on_grid.y * grid_pos.y
	)
	
	return pos + tile_center


func _tile_to_grid(tile_pos: Vector2i):
	var pos = tile_pos - tile_center
	if pos.x < 0 and pos.x % tile_size_on_grid.x != 0:
		pos.x -= (tile_size_on_grid.x + pos.x % tile_size_on_grid.x)
	if pos.y < 0 and pos.y % tile_size_on_grid.y != 0:
		pos.y -= (tile_size_on_grid.y + pos.y % tile_size_on_grid.y) 
	
	return pos / tile_size_on_grid
