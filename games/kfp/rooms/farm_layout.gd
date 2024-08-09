class_name FarmLayout
extends TileLayerHighlight

@onready var grass: TileMapLayer = $Grass
@onready var dirt: TileMapLayer = $Dirt
@onready var fence: TileMapLayer = $Fence

func get_layers():
	return [grass, dirt, fence]
