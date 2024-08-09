extends Node2D

@export var dropped_egg_scene: PackedScene
@export var chicken_scene: PackedScene
@export var chicken_details: ChickenDetails
@export var tile_map: TileMapLayer

@onready var throttle_spawn_dropped_eggs: Timer = $ThrottleSpawnDroppedEggs

var selected_chicken: ChickenResource:
	set(v):
		selected_chicken = v
		chicken_details.show_chicken(v)

var egg_drop_value := 0.0:
	set(v):
		egg_drop_value = v
		if egg_drop_value >= 1.0 and throttle_spawn_dropped_eggs.is_stopped():
			var amount = _spawn_dropped_egg(egg_drop_value)
			egg_drop_value -= amount

func _ready():
	KfpManager.hatching_eggs = []
	
	for chicken in KfpManager.chickens:
		_spawn_chicken(chicken, _get_random_tile_position())
	
	KfpManager.chicken_added.connect(func(res, pos): _spawn_chicken(res, pos))
	
	chicken_details.close.connect(func(): self.selected_chicken = null)
	chicken_details.butcher_chicken.connect(func(res):
		KfpManager.butcher_chicken(res)
		self.selected_chicken = null
	)
	
func _process(delta: float) -> void:
	self.egg_drop_value += delta * KfpManager.get_chicken_egg_drop_rate()

func _get_random_tile_position():
	var cells = tile_map.get_used_cells()
	return tile_map.map_to_local(cells.pick_random())

func _spawn_dropped_egg(value: float):
	var node = dropped_egg_scene.instantiate()
	node.amount = floor(value)
	node.global_position = _get_random_tile_position()
	add_child(node)
	
	throttle_spawn_dropped_eggs.start()
	return node.amount

func _spawn_chicken(chicken: ChickenResource, pos = Vector2.ZERO):
	var node = chicken_scene.instantiate()
	node.res = chicken
	node.global_position = pos
	node.clicked_chicken.connect(func(): self.selected_chicken = chicken)
	add_child(node)

func _on_restaurant_pressed():
	get_tree().change_scene_to_file("res://games/kfp/kfp_game.tscn")
