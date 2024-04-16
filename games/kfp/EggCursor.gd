extends Node2D

const GROUND_LAYER = 0
const GROUND_SOURCE = 3

@export var cursor: SnappedCursor
@export var chicken_manager: ChickenManager
@export var chicken_scene: PackedScene
@export var spawn_root: Node2D

@onready var egg_spawner = $EggSpawner

var is_placing := false:
	set(v):
		is_placing = v
		cursor.is_focused = v

func toggle_place_eggs():
	self.is_placing = not is_placing

func _unhandled_input(event):
	if not is_placing: return
	
	if event.is_action_pressed("action"):
		egg_spawner.global_position = cursor.global_position
		_place_hatching_egg()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("cancel"):
		cursor.is_focused = false
		get_viewport().set_input_as_handled()

func _spawn_chicken(pos: Vector2):
	var chicken = chicken_scene.instantiate()
	spawn_root.add_child(chicken)
	chicken.global_position = pos
	chicken_manager.add_chicken(chicken)

func _place_hatching_egg():
	if chicken_manager.total_eggs <= 0:
		print("NO EGGS")
		return
	
	var coord = cursor.get_map_position()
	var rect = Util.tilemap_layer_rect(cursor.tile_map, GROUND_LAYER, GROUND_SOURCE) as Rect2i
	rect = rect.grow_side(SIDE_LEFT, -1).grow_side(SIDE_TOP, -1)
	
	if not rect.has_point(coord):
		print("Outside of placeable tiles")
		return
		
	_spawn_egg()
	
	chicken_manager.total_eggs -= 1
	if chicken_manager.total_eggs <= 0:
		cursor.is_focused = false

func _spawn_egg():
	var egg = egg_spawner.spawn()
	egg.hatched.connect(func():
		if chicken_manager.is_max_chickens():
			return
		
		_spawn_chicken(egg.global_position)
		egg.queue_free()
	)
