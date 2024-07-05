class_name MapTileArea
extends TileMap

@export var end_marker: Marker2D

func get_last_position():
	return Vector2(0, end_marker.global_position.y)
