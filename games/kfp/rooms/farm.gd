extends Node2D

@export var chicken_scene: PackedScene

func _ready():
	for chicken in KfpManager.chickens:
		_spawn_chicken(chicken)
	KfpManager.chicken_added.connect(func(res, pos): _spawn_chicken(res, pos))

func _spawn_chicken(chicken: ChickenResource, pos = Vector2.ZERO):
	var node = chicken_scene.instantiate()
	node.res = chicken
	node.global_position = pos
	add_child(node)

func _on_egg_pack_pressed():
	KfpManager.buy_egg() # TODO: gacha


func _on_restaurant_pressed():
	get_tree().change_scene_to_file("res://games/kfp/kfp_game.tscn")
