class_name KFP
extends Node2D

signal order_added(id)
signal order_completed(id)
signal order_failed(id)

@onready var cursor = $TileMap/EggCursor
@onready var ordering = $TileMap/Ordering
@onready var tile_map = $TileMap
@onready var order_desk = $TileMap/OrderDesk

@export_category("Camera")
@export var room_source := 0
@export var farm_source := 3
@onready var fit_camera = $FitCamera
@onready var farm_enter = $FarmEnter
@onready var room_enter = $RoomEnter
@onready var farm_effect_runner = $FarmEffectRunner
@onready var game_effect_runner = $GameEffectRunner

var order_id := 1
var orders := {}

func _ready():
	farm_enter.body_entered.connect(func(_x):
		fit_camera.update(farm_source)
		farm_effect_runner.open()
		game_effect_runner.close()
	)
	room_enter.body_entered.connect(func(_x):
		fit_camera.update(room_source)
		farm_effect_runner.close()
		game_effect_runner.open()
	)
	order_desk.ordered.connect(func(c): _add_order(c))

func _add_order(customer):
	orders[order_id] = customer
	customer.taken_order(order_id)
	order_added.emit(customer)
	order_id += 1

func _on_egg_action_pressed():
	cursor.is_focused = not cursor.is_focused
