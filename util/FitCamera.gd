class_name FitCamera
extends Camera2D

@export var source := 0
@export var tilemap: TileMap
@export var margin := 0
@onready var tile_size = tilemap.tile_set.tile_size

func _ready():
	#update(source)
	await get_tree().create_timer(0.5).timeout
	position_smoothing_enabled = true

func update(s = source):
	var rect = Util.tilemap_layer_rect(tilemap, 0, s)
	rect = rect.grow(margin)
	
	_center_camera(rect)
	_zoom_camera_fit(rect.size)

func _center_camera(rect):
	var global_center = tilemap.map_to_local(rect.get_center())
	
	var size = rect.size
	if size.x % 2 != 0:
		global_center.x += tile_size.x / 2
	if size.y % 2 != 0:
		global_center.y += tile_size.y / 2
	
	global_position = global_center

func _zoom_camera_fit(size):
	# TODO: fit for vertical screen?
	var map_size = size.y + 1
	var global_size = (map_size * tile_size.y)
	var zoom_amount = get_viewport_rect().size.y / global_size
	zoom = Vector2(zoom_amount, zoom_amount)
