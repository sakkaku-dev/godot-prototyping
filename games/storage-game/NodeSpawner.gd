class_name NodeSpawner
extends Node3D

@export var package: PackedScene
@export var grid: PackageGridMap
@export var init := false

func _ready():
	if init:
		spawn()

func spawn():
	var node = package.instantiate()
	_init_node(node)
	add_child(node)
	if not grid.add_object(grid.get_coord(global_position), node, true):
		node.queue_free()

func _init_node(node):
	pass
