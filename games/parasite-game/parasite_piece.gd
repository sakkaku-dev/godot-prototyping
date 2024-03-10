extends CharacterBody2D

signal pressed()

@onready var navigation_move_2d = $NavigationMove2D

var coord := Vector2i.ZERO

func move_to(target: Vector2):
	navigation_move_2d.set_target(target)

func moveable_tiles(tilemap: FixedTileMap):
	var x = tilemap.get_neighbors(coord)
	x.append(coord)
	return x

func attackable_tiles(tilemap: FixedTileMap):
	return tilemap.get_neighbors(coord, false)
