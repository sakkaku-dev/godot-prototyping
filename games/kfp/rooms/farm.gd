extends Node2D

@export var chicken_scene: PackedScene

func _ready():
	for chicken in KfpManager.chickens:
		_spawn_chicken(chicken)
	KfpManager.chicken_added.connect(_spawn_chicken)

func _spawn_chicken(chicken: ChickenResource):
	var node = chicken_scene.instantiate()
	node.res = chicken
	add_child(node)

func _on_egg_pack_pressed():
	KfpManager.add_random_chicken() # TODO: gacha


func _on_restaurant_pressed():
	get_tree().change_scene_to_file("res://games/kfp/kfp_game.tscn")
