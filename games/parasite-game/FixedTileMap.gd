class_name FixedTileMap
extends TileMap

static var NEIGHBORS = [
	Vector2i.UP,
	Vector2i.LEFT,
	Vector2i.RIGHT,
	Vector2i.DOWN,
]

static var DIAGONAL_NEIGHBORS = [
	Vector2i(1, 1),
	Vector2i(1, -1),
	Vector2i(-1, 1),
	Vector2i(-1, -1),
]

@export var size := Vector2i(8, 8)
@export var source := 0
@export var layer := 0
@export var atlas := Vector2i(10, 1)

func _ready():
	clear()
	for x in size.x:
		for y in size.y:
			set_cell(layer, Vector2i(x, y), source, atlas)

func random_tile(exclude := [], l := layer):
	var cells = get_used_cells(l).filter(func(x): return not x in exclude)
	return cells.pick_random() if cells.size() > 0 else null

func get_neighbors(coord: Vector2i, include_diagonals := true, include_straights := true):
	var dirs = []
	
	if include_straights:
		dirs.append_array(NEIGHBORS)
	if include_diagonals:
		dirs.append_array(DIAGONAL_NEIGHBORS)
	
	return get_coords_for(dirs, coord)

func has_value(coord: Vector2i):
	return get_cell_source_id(layer, coord) != -1

func get_coords_for(dirs: Array, center: Vector2i):
	return dirs.map(func(d): return center + d).filter(func(c): return get_cell_source_id(layer, c) != -1)
