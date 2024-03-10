class_name TileMapCamera
extends Camera2D

@export var extra_zoom := 0.0
@export var tilemap: FixedTileMap
@onready var tile_size = tilemap.tile_set.tile_size

func _ready():
	_center_camera(tilemap.size)
	_zoom_camera_fit()

func _center_camera(board_size):
	var center = Vector2(floor(board_size.x / 2), floor(board_size.y / 2))
	var global_center = tilemap.map_to_local(center)
	if board_size.x % 2 == 0:
		global_center -= Vector2(tile_size) / 2
	global_position = global_center

func _zoom_camera_fit():
	# TODO: fit for vertical screen?
	var map_size = tilemap.get_used_rect().size.y - 1
	var global_size = map_size * tile_size.y
	var zoom_amount = get_viewport_rect().size.y / global_size + extra_zoom
	zoom = Vector2(zoom_amount, zoom_amount)
