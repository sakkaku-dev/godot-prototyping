class_name Room
extends Node2D

enum Placement {
	WORK_AREA,
	INTERIOR,
}

@export var dim_color := Color.DIM_GRAY

@onready var floor_tiles: TileMapLayer = $FloorTiles
@onready var wall_tiles: TileMapLayer = $WallTiles
@onready var interior_tiles: TileMapLayer = $InteriorTiles
@onready var work_area_tiles: TileMapLayer = $WorkAreaTiles
@onready var custom_tiles: TileMapLayer = $CustomTiles

@onready var premade_tiles := [floor_tiles, wall_tiles, interior_tiles, work_area_tiles]

func highlight_area(place: Placement):
	for tile in premade_tiles:
		tile.modulate = dim_color
	
	_get_tiles_for_placement(place).modulate = Color.WHITE

func _get_tiles_for_placement(place: Placement) -> TileMapLayer:
	match place:
		Placement.WORK_AREA: return work_area_tiles
		Placement.INTERIOR: return interior_tiles
	
	return null
	
func reset_highlight():
	for tile in premade_tiles:
		tile.modulate = Color.WHITE

func place_tile(tile: RoomItemTile, coord: Vector2i):
	var tiles = _get_tiles_for_placement(tile.placement)
	if not coord in tiles.get_used_cells():
		print("Coord %s is not in tiles for %s" % [coord, Placement.keys()[tile.placement]])
		return false
	
	custom_tiles.set_cell(coord, tile.source_id, Vector2.ZERO, tile.item_id)
	return true

func clear_tile(coord: Vector2i):
	custom_tiles.set_cell(coord, -1)
	
