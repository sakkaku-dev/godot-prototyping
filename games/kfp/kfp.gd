class_name KFP
extends Node2D

@export var chicken_scene: PackedScene
@export var egg_scene: PackedScene
@export var total_eggs_label: Label

@onready var place_marker = $TileMap/PlaceMarker
@onready var ordering = $TileMap/Ordering
@onready var tile_map = $TileMap
@onready var mini_game = $MiniGame

@export var room_layer := 3
@export var farm_layer := 2
@onready var fit_camera = $FitCamera
@onready var farm_enter = $FarmEnter
@onready var room_enter = $RoomEnter

const GROUND_LAYER = 1

var total_eggs := 0:
	set(x):
		total_eggs = x
		total_eggs_label.text = "%s" % total_eggs
		
var place_egg := false

func _ready():
	farm_enter.body_entered.connect(func(_x): fit_camera.update(farm_layer))
	room_enter.body_entered.connect(func(_x): fit_camera.update(room_layer))

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
	var rect = Util.tilemap_layer_rect(tile_map, GROUND_LAYER) as Rect2i
	print(rect.size)
	print(rect.position, " - ", rect.end)
	rect = rect.grow_side(SIDE_LEFT, -1).grow_side(SIDE_TOP, -1)
	
	
	if not rect.has_point(coord):
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
	
	if total_eggs <= 0:
		_stop_place_eggs()

func _spawn_chicken(pos: Vector2):
	var chicken = chicken_scene.instantiate()
	ordering.add_child(chicken)
	chicken.global_position = pos
