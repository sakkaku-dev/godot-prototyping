class_name SnappedCursor
extends Node2D

@export var tile_map: TileMap

@export var is_focused := false:
	set(v):
		is_focused = v
		visible = v

func _ready():
	hide()

func _process(delta):
	global_position = tile_map.map_to_local(get_map_position())

func get_map_position():
	return tile_map.local_to_map(global_position)
