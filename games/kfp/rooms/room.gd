class_name Room
extends TileLayerHighlight

enum Placement {
	WORK_AREA,
	INTERIOR,
}

@onready var floor_tiles: TileMapLayer = $FloorTiles
@onready var wall_tiles: TileMapLayer = $WallTiles
@onready var interior_tiles: TileMapLayer = $InteriorTiles
@onready var work_area_tiles: TileMapLayer = $WorkAreaTiles
@onready var custom_tiles: TileMapLayer = $CustomTiles

@onready var premade_tiles := [floor_tiles, wall_tiles, interior_tiles, work_area_tiles]

func get_layers():
	return premade_tiles

func highlight_area(place: Placement):
	highlight(_get_tiles_for_placement(place))

func _get_tiles_for_placement(place: Placement) -> TileMapLayer:
	match place:
		Placement.WORK_AREA: return work_area_tiles
		Placement.INTERIOR: return interior_tiles
	
	return null

func place_tile(tile: RoomItemTile, coord: Vector2i):
	var tiles = _get_tiles_for_placement(tile.placement)
	if not coord in tiles.get_used_cells():
		print("Coord %s is not in tiles for %s" % [coord, Placement.keys()[tile.placement]])
		return false
		
	if custom_tiles.get_cell_source_id(coord) != -1:
		print("Coord %s already has an item there" % [coord])
		return false
	
	custom_tiles.set_cell(coord, tile.source_id, Vector2.ZERO, tile.item_id)
	return true

func clear_tile(coord: Vector2i):
	if not coord in custom_tiles.get_used_cells():
		return -1
	
	var alternative = custom_tiles.get_cell_alternative_tile(coord)
	custom_tiles.set_cell(coord, -1)
	return alternative
