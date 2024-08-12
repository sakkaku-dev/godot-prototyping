class_name FarmLayout
extends TileLayerHighlight

@onready var grass: TileMapLayer = $Grass
@onready var dirt: TileMapLayer = $Dirt
@onready var fence: TileMapLayer = $Fence
@onready var custom_tiles: TileMapLayer = $Custom

func _ready() -> void:
	KfpManager.farm_size_changed.connect(_update)
	_update()

func _update():
	dirt.clear()
	fence.clear()
	
	var size = sqrt(KfpManager.max_farm_size)
	var ground_cells = []
	for x in range(-size, size):
		for y in range(-size, size):
			ground_cells.append(Vector2i(x, y))
	dirt.set_cells_terrain_connect(ground_cells, 0, 2)
	
	var fence_cells = []
	for x in range(-size-1, size+1):
		fence_cells.append(Vector2i(x, -size-1))
		fence_cells.append(Vector2i(x, size))
	for y in range(-size, size):
		fence_cells.append(Vector2i(-size-1, y))
		fence_cells.append(Vector2i(size, y))
	fence.set_cells_terrain_connect(fence_cells, 0, 1)

func get_layers():
	return [grass, dirt, fence]

func get_tiles_for_placement(place: Placement) -> TileMapLayer:
	match place:
		Placement.CUSTOM: return custom_tiles
	
	return dirt

func has_item_at(coord: Vector2i):
	return KfpManager.get_farm_item(coord) != ""
