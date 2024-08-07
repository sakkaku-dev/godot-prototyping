extends Node2D

@export var chicken_scene: PackedScene
@export var chicken_details: ChickenDetails

var selected_chicken: ChickenResource:
	set(v):
		selected_chicken = v
		chicken_details.show_chicken(v)


func _ready():
	for chicken in KfpManager.chickens:
		_spawn_chicken(chicken)
	KfpManager.chicken_added.connect(func(res, pos): _spawn_chicken(res, pos))
	chicken_details.butcher_chicken.connect(func(res):
		KfpManager.butcher_chicken(res)
		self.selected_chicken = null
	)


func _spawn_chicken(chicken: ChickenResource, pos = Vector2.ZERO):
	var node = chicken_scene.instantiate()
	node.res = chicken
	node.global_position = pos
	node.clicked_chicken.connect(func(): self.selected_chicken = chicken)
	add_child(node)

func _on_restaurant_pressed():
	get_tree().change_scene_to_file("res://games/kfp/kfp_game.tscn")
