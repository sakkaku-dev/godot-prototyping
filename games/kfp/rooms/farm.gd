class_name Farm
extends Node2D

signal move_to_restaurant()

@export var dropped_egg_scene: PackedScene
@export var chicken_scene: PackedScene
@export var tile_map: TileMapLayer

@onready var throttle_spawn_dropped_eggs: Timer = $ThrottleSpawnDroppedEggs
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var placing_tile: TilePlacement:
	set(v):
		placing_tile = v

var selected_chicken: Chicken:
	set(v):
		if is_instance_valid(selected_chicken):
			selected_chicken.set_selected(false)
		selected_chicken = v
		
		if is_instance_valid(selected_chicken):
			selected_chicken.set_selected(true)

var egg_drop_value := 0.0:
	set(v):
		egg_drop_value = v
		if egg_drop_value >= 1.0 and throttle_spawn_dropped_eggs.is_stopped():
			var amount = _spawn_dropped_egg(egg_drop_value)
			egg_drop_value -= amount

func _ready():
	for chicken in KfpManager.chickens:
		_spawn_chicken(chicken, _get_random_tile_position())
	
	KfpManager.chicken_added.connect(func(res, pos): _spawn_chicken(res, pos))
	KfpManager.chicken_removed.connect(func(res): if not is_instance_valid(selected_chicken) or selected_chicken.res == res: self.selected_chicken = null)
	
	#chicken_details.close.connect(func(): self.selected_chicken = null)
	#chicken_details.butcher_chicken.connect(func(res):
		#KfpManager.butcher_chicken(res)
		#self.selected_chicken = null
	#)
	
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
	node.clicked_chicken.connect(func(): self.selected_chicken = node)
	add_child(node)

func _on_restaurant_pressed():
	move_to_restaurant.emit()

func set_placing_tile(tile: TilePlacement):
	self.placing_tile = tile

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and self.placing_tile:
		self.placing_tile = null
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("action") and selected_chicken:
		self.selected_chicken = null
