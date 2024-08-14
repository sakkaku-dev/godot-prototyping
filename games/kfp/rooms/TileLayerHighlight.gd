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

func _map_coord() -> Vector2i:
	return get_tiles_for_placement(Placement.CUSTOM).local_to_map(global_position)

func place_tile(tile: RoomItemTile, coord: Vector2i):
	var tiles = get_tiles_for_placement(tile.placement)
	
	var local_coord = coord - _map_coord()
	if not local_coord in tiles.get_used_cells():
		print("Coord %s is not in tiles for %s" % [local_coord, Placement.keys()[tile.placement]])
		return false
	
	if has_item_at(local_coord):
		print("Coord %s already has an item there" % [local_coord])
		return false
	
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	custom.set_cell(local_coord, -1)
	custom.set_cell(local_coord, source_id, Vector2.ZERO, TYPE_ID_MAP[tile.count.item])
	return true

func has_item_at(coord: Vector2i):
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	return custom.get_cell_source_id(coord) != -1

func clear_tile(coord: Vector2i):
	var local_coord = coord - _map_coord()
	var custom = get_tiles_for_placement(Placement.CUSTOM)
	if not local_coord in custom.get_used_cells():
		print("No object at %s" % coord)
		return -1
	
	var alternative = custom.get_cell_alternative_tile(local_coord)
	custom.set_cell(local_coord, -1)
	return idTypeMap[alternative]
