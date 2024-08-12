#class_name TilePlaceholder
#extends Sprite2D
#
#@export var layer: TileMapLayer
#@export var tile_highlight: TileLayerHighlight
#
#func _ready() -> void:
	#visibility_changed
#
#func _update():
	#if visible:
		#tile_highlight.highlight(layer)
	#else:
		#tile_highlight.reset_highlight()
#
#func _process(delta):
	#if not visible: return
	#global_position = _current_pos()
#
#func _current_pos():
	#return layer.map_to_local(get_current_coord())
#
#func get_current_coord():
	#return layer.local_to_map(get_global_mouse_position())
#
#func is_valid_coord():
	#return get_current_coord() in layer.get_used_cells()
