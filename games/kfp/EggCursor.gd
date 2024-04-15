extends Cursor

const GROUND_LAYER = 1

@export var chicken_manager: ChickenManager
@export var chicken_scene: PackedScene
@export var spawn_root: Node2D

@onready var egg_spawner = $EggSpawner
@onready var place_marker = $PlaceMarker

func _unhandled_input(event):
	if not is_focused: return
	super._unhandled_input(event)
	
	if event.is_action_pressed("action"):
		_place_hatching_egg()
	elif event.is_action_pressed("cancel"):
		self.is_focused = false

func _spawn_chicken(pos: Vector2):
	var chicken = chicken_scene.instantiate()
	spawn_root.add_child(chicken)
	chicken.global_position = pos
	chicken_manager.add_chicken(chicken)

func _place_hatching_egg():
	if chicken_manager.total_eggs <= 0:
		print("NO EGGS")
		return
	
	var coord = get_map_position()
	var rect = Util.tilemap_layer_rect(tile_map, GROUND_LAYER) as Rect2i
	rect = rect.grow_side(SIDE_LEFT, -1).grow_side(SIDE_TOP, -1)
	
	if not rect.has_point(coord):
		print("Outside of placeable tiles")
		return
		
	_spawn_egg()
	
	chicken_manager.total_eggs -= 1
	if chicken_manager.total_eggs <= 0:
		self.is_focused = false

func _spawn_egg():
	var egg = egg_spawner.spawn()
	egg.hatched.connect(func():
		if chicken_manager.is_max_chickens():
			return
		
		_spawn_chicken(egg.global_position)
		egg.queue_free()
	)
