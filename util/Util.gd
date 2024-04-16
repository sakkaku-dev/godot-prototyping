class_name Util

static func tilemap_layer_rect(tile_map: TileMap, layer, source = null) -> Rect2i:
	var cells = tile_map.get_used_cells(layer)
	
	if source != null:
		cells = cells.filter(func(c): return tile_map.get_cell_source_id(layer, c) == source)
	
	if cells.is_empty():
		return Rect2i()
	
	var min_coord = Vector2i(10000, 10000)
	var max_coord = Vector2i(0, 0)
	for c in cells:
		min_coord.x = min(min_coord.x, c.x)
		min_coord.y = min(min_coord.y, c.y)
		max_coord.x = max(max_coord.x, c.x)
		max_coord.y = max(max_coord.y, c.y)
	
	return Rect2i(min_coord, max_coord - min_coord)
