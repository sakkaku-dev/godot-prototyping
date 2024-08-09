class_name TileLayerHighlight
extends Node2D

@export var dim_color := Color.DIM_GRAY

func get_layers() -> Array:
	return []

func highlight(layer: TileMapLayer):
	for tile in get_layers():
		tile.modulate = dim_color
	
	layer.modulate = Color.WHITE

func reset_highlight():
	for tile in get_layers():
		tile.modulate = Color.WHITE
