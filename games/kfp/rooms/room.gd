class_name Room
extends TileLayerHighlight

@onready var floor_tiles: TileMapLayer = $FloorTiles
@onready var wall_tiles: TileMapLayer = $WallTiles
@onready var interior_tiles: TileMapLayer = $InteriorTiles
@onready var work_area_tiles: TileMapLayer = $WorkAreaTiles
@onready var custom_tiles: TileMapLayer = $CustomTiles

@onready var premade_tiles := [floor_tiles, wall_tiles, interior_tiles, work_area_tiles]

func get_layers():
	return premade_tiles

func get_tiles_for_placement(place: Placement) -> TileMapLayer:
	match place:
		Placement.WORK_AREA: return work_area_tiles
		Placement.INTERIOR: return interior_tiles
		Placement.CUSTOM: return custom_tiles
	
	return null
