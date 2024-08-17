extends Node3D

@export var min_items := 1

func _ready() -> void:
	var spawner = get_children()
	spawner.pick_random().spawn_item()
