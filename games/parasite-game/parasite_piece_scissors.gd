extends ParasitePiece

func moveable_tiles(center = coord):
	return tilemap.get_used_cells(tilemap.layer).filter(func(c): return (c.x == center.x or c.y == center.y) and center != c)
	
func attackable_tiles(center = coord):
	return tilemap.get_neighbors(center, false)

func _ai_move_to_player(player: ParasitePiece, moves: Array):
	return super.smallest_distance(player.coord, moves)
