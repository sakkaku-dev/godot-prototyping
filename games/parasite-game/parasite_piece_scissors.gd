extends ParasitePiece

func moveable_tiles(tilemap: FixedTileMap):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == coord.x or c.y == coord.y) and coord != c)
	
func attackable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord)
