extends Node2D

@export var highlight_color: Color
@export var tilemap: TileMap
@export var layer := 0
@onready var tile_size := tilemap.tile_set.tile_size

var highlight_coords := []:
	set(v):
		var cells = tilemap.get_used_cells(layer)
		highlight_coords = v.filter(func(c): return c in cells)
		
		for c in get_children():
			remove_child(c)
		
		for c in highlight_coords:
			var rect = ColorRect.new()
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			rect.color = highlight_color
			rect.size = tile_size
			rect.global_position = tilemap.map_to_local(c) - Vector2(tile_size / 2.0)
			add_child(rect)
