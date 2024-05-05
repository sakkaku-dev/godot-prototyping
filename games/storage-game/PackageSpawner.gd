extends Node3D

@export var package: PackedScene
@export var grid: PackageGridMap
@export var init := false

func _ready():
	if init:
		spawn()

func spawn():
	var node = package.instantiate()
	add_child(node)
	grid.add_object(grid.get_coord(global_position), node, true)
	print("Spawning object at %s" % global_position)
