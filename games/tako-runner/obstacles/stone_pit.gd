extends Node2D

@export var depth := 9
@export var size := 7

@onready var tile_map: TileMap = get_tree().get_first_node_in_group("map")

func _ready():
	var coord = tile_map.local_to_map(global_position)
	for x in size:
		for y in depth:
			tile_map.set_cell(0, Vector2i(coord.x + x, y), -1)
