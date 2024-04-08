class_name KFP
extends Node2D

@export var chicken_scene: PackedScene
@export var egg_scene: PackedScene
@export var total_eggs_label: Label

@onready var place_marker = $PlaceMarker
@onready var ordering = $TileMap/Ordering
@onready var tile_map = $TileMap
@onready var mini_game = $MiniGame

const GROUND_LAYER = 1

var total_eggs := 0:
	set(x):
		total_eggs = x
		total_eggs_label.text = "%s" % total_eggs
		
var place_egg := false

func _on_egg_catch_game_total_eggs_collected(eggs):
	self.total_eggs += eggs

func _on_egg_action_pressed():
	if place_egg:
		_stop_place_eggs()
	else:
		place_egg = true
		place_marker.follow()
		
func _stop_place_eggs():
	place_egg = false
	place_marker.unfollow()

func _unhandled_input(event):
	if place_egg:
		if event.is_action_pressed("action"):
			_place_hatching_egg()
		elif event.is_action_pressed("cancel"):
			_stop_place_eggs()
			
func _place_hatching_egg():
	if total_eggs <= 0:
		print("NO EGGS")
		return
	
	var coord = tile_map.local_to_map(get_global_mouse_position())
	
	#if tile_map.get_cell_source_id(GROUND_LAYER, coord) == -1:
		#print("Eggs can only be placed on the ground")
		#return
		
	var cells = tile_map.get_used_cells(GROUND_LAYER)
	var min_coord = Vector2i(1000, 1000)
	var max_coord = Vector2i(0, 0)
	for c in cells:
		min_coord.x = min(min_coord.x, c.x)
		min_coord.y = min(min_coord.y, c.y)
		max_coord.x = max(max_coord.x, c.x)
		max_coord.y = max(max_coord.y, c.y)
		
	if coord.x <= min_coord.x or coord.x >= max_coord.x or coord.y <= min_coord.y or coord.y >= max_coord.y:
		print("Outside of placeable tiles")
		return
	
	var egg = egg_scene.instantiate()
	ordering.add_child(egg)
	egg.global_position = tile_map.map_to_local(coord)
	egg.mini_game = mini_game
	egg.hatched.connect(func():
		_spawn_chicken(egg.global_position)
		egg.queue_free()
	)
	self.total_eggs -= 1

func _spawn_chicken(pos: Vector2):
	var chicken = chicken_scene.instantiate()
	ordering.add_child(chicken)
	chicken.global_position = pos
