extends Node2D

@onready var tile_map = $TileMap
@onready var player = $Player
@onready var enemy_map_spawner = $EnemyMapSpawner

func _ready():
	tile_map.generate()
	player.global_position = tile_map.get_lowest_position()
	enemy_map_spawner.spawn()
