extends Node3D

@export var items: Array[ItemResource.Type] = []

func _ready() -> void:
	var spawner = get_children()
	for item in items:
		var child = spawner.pick_random()
		spawner.erase(child)
		child.spawn_item(item)
