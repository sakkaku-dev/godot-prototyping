extends Node2D

@onready var tile_map = $TileMap
@onready var player = $Player

func _ready():
	tile_map.generate()
	player.global_position = tile_map.get_lowest_position()
