extends Node3D


const SCENES = {
	ItemResource.Type.Coin: preload("res://games/build-scale/items/coin_object.tscn"),
	ItemResource.Type.CoinHole: preload("res://games/build-scale/items/coin_hole.tscn"),
	ItemResource.Type.CoinDouble: preload("res://games/build-scale/items/coin_double.tscn"),
	ItemResource.Type.EndCoinAdd: preload("res://games/build-scale/items/end_coin_add.tscn"),
	ItemResource.Type.EndCoinDouble: preload("res://games/build-scale/items/end_coin_multiply.tscn"),
}

@export var type := ItemResource.Type.Coin

func _ready() -> void:
	for c in get_children():
		c.queue_free()

func _available_items():
	return ItemResource.Type.values()

func spawn_item(type = _available_items().pick_random()):
	var item = type
	if item != null:
		var node = SCENES[type].instantiate()
		add_child(node)
