class_name PlacementArrow
extends Node3D

@export var grid: GridMap
@export var root: Node3D

func _process(delta):
	if not visible: return
	
	var coord = grid.local_to_map(root.global_position)
	global_position = grid.map_to_local(Vector3i(coord.x, 0, coord.z))

func get_placement_position():
	if is_valid_position():
		return global_position
	return null

func is_valid_position():
	var coord = grid.local_to_map(root.global_position)
	return grid.get_cell_item(coord) != GridMap.INVALID_CELL_ITEM
