extends Node3D

@export var package: PackedScene
@export var grid: PackageGridMap

func spawn():
	var node = package.instantiate()
	var pos = grid.get_placement_position(global_position)
	add_child(node)
	node.global_position = pos
