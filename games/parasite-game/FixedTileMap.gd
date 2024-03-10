class_name FixedTileMap
extends TileMap

static var NEIGHBORS = [
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
	TileSet.CELL_NEIGHBOR_TOP_SIDE,
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
]

static var DIAGONAL_NEIGHBORS = [
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
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

func get_neighbors(coord: Vector2i, include_diagonals := true):
	var dirs = NEIGHBORS.duplicate()
	
	if include_diagonals:
		dirs.append_array(DIAGONAL_NEIGHBORS)
	
	return dirs.map(func(d): return get_neighbor_cell(coord, d))
