class_name PlacementArrow
extends Node3D

@export var grid: PackageGridMap
@export var root: Node3D

func _process(delta):
	if not visible: return
	global_position = grid.get_placement_position(grid.local_to_map(root.global_position))

func get_coord():
	return grid.local_to_map(global_position)
