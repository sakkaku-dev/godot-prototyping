extends Node3D

@export var spawn_chance := 0.3

const COIN_ITEM = preload("res://games/build-scale/items/coin_item.tscn")

func _ready() -> void:
	for c in get_children():
		c.queue_free()
	
	if randf() <= spawn_chance:
		_spawn_item()

func _available_items():
	return ItemResource.Type.values()

func _spawn_item():
	var item = _available_items().pick_random()
	if item:
		var node = COIN_ITEM.instantiate()
		node.item = item
		add_child(node)
