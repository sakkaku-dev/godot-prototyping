class_name PlaceMarkerMouse
extends ColorRect

@export var tilemap: TileMap
@export var follow_mouse := false

func _ready():
	size = tilemap.tile_set.tile_size
	hide()
	
func _process(delta):
	if follow_mouse:
		var pos = tilemap.get_global_mouse_position()
		var coord = tilemap.local_to_map(pos)
		var snapped_pos = tilemap.map_to_local(coord)
		
		global_position = snapped_pos - size / 2

func follow():
	show()
	follow_mouse = true

func unfollow():
	hide()
	follow_mouse = false
