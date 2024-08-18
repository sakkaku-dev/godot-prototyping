class_name CoinItem
extends Area3D

const SPRITES = {
	ItemResource.Type.Coin: preload("res://games/build-scale/items/coin_object.tscn"),
	ItemResource.Type.CoinHole: preload("res://games/build-scale/items/coin_hole.tscn"),
	ItemResource.Type.CoinDouble: preload("res://games/build-scale/items/coin_double.tscn"),
}

@onready var sprite_3d: Sprite3D = $Sprite3D

var item: ItemResource.Type

func _ready() -> void:
	if item in SPRITES:
		sprite_3d.queue_free()
		add_child(SPRITES[item].instantiate())
	#sprite_3d.texture = SPRITES[item] if item in SPRITES else load("res://icon.svg")
