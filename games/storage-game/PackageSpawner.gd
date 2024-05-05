extends Node3D

@export var package: PackedScene
@export var grid: PackageGridMap

func spawn():
	var node = package.instantiate()
	add_child(node)
	grid.add_package(global_position, node)
	print("Spawning package at %s" % global_position)
