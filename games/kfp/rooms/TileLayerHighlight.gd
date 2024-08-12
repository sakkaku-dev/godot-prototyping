class_name TileLayerHighlight
extends Node2D

enum Placement {
	WORK_AREA,
	INTERIOR,
	CUSTOM,
}

const TYPE_ID_MAP = {
	KfpUpgradeManager.CUTTING_BOARD: 1,
	KfpUpgradeManager.ORDER_DESK: 2,
	KfpUpgradeManager.TAKEOUT_DESK: 3,
	KfpUpgradeManager.EGG: 4,
	KfpUpgradeManager.FARM_NEST: 5,
	KfpUpgradeManager.BUTCHER_HOUSE: 6,
}

@onready var idTypeMap = TYPE_ID_MAP.keys() \
	.reduce(func(acc, key):
		acc[TYPE_ID_MAP[key]] = key
		return acc, {})

@export var source_id := 0
@export var dim_color := Color.DIM_GRAY

func get_layers() -> Array:
	return []

func highlight(layer: TileMapLayer):
	for tile in get_layers():
		tile.modulate = dim_color
	
	layer.modulate = Color.WHITE

func highlight_area(place: Placement):
	highlight(get_tiles_for_placement(place))

func reset_highlight():
	for tile in get_layers():
		tile.modulate = Color.WHITE

func get_tiles_for_placement(place: Placement) -> TileMapLayer:
	return null

func place_tile(tile: RoomItemTile, coord: Vector2i):
	var tiles = get_tiles_for_placement(tile.placement)
	if not coord in tiles.get_used_cells():
		print("Coord %s is not in tiles for %s" % [coord, Placement.keys()[tile.placement]])
		return false
	
	if has_item_at(coord):
		print("Coord %s already has an item there" % [coord])
		return false
	
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	custom.set_cell(coord, -1)
	custom.set_cell(coord, source_id, Vector2.ZERO, TYPE_ID_MAP[tile.count.item])
	return true

func has_item_at(coord: Vector2i):
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	return custom.get_cell_source_id(coord) != -1

func clear_tile(coord: Vector2i):
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	if not coord in custom.get_used_cells():
		print("No object at %s" % coord)
		return -1
	
	var alternative = custom.get_cell_alternative_tile(coord)
	custom.set_cell(coord, -1)
	return idTypeMap[alternative]
