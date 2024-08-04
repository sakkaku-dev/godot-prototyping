class_name KFP
extends Node2D

const GROUP = "KFP"

signal order_added(id)
signal order_completed(id)
signal order_failed(id)

@onready var cursor = $TileMap/EggCursor
@onready var ordering = $TileMap/Ordering
@onready var tile_map = $TileMap
@onready var order_desk = $TileMap/Ordering/OrderDesk
@onready var customer_manager = $CustomerManager

@export_category("Camera")
@export var room_source := 1
@export var farm_source := 2
@onready var fit_camera = $FitCamera
@onready var farm_enter = $FarmEnter
@onready var room_enter = $RoomEnter
@onready var farm_effect_runner = $FarmEffectRunner
@onready var game_effect_runner = $GameEffectRunner

var money := 0:
	set(v):
		money = v
		print(v)

var order_id := 1
var orders := {}
var order_numbers := []

static func get_object(x: Node) -> KFP:
	return x.get_tree().get_first_node_in_group(GROUP)

func _ready():
	InputMapper.override_key_inputs({
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"move_up": [KEY_W],
		"move_down": [KEY_S],
		"interact": [KEY_SPACE],
		"action": [KEY_SPACE],
		"cancel": [KEY_ESCAPE],
		"slot_1": [KEY_1],
		"slot_2": [KEY_2],
		"rotate": [KEY_R],
	})
	
	add_to_group(GROUP)
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

func is_open():
	return customer_manager.is_open()

func _add_order(customer):
	orders[order_id] = customer
	order_numbers.append(order_id)
	
	customer.taken_order(order_id)
	customer.leaving.connect(func(): _remove_customer(customer))
	order_added.emit(customer)
	order_id += 1

func _remove_customer(c: Customer):
	var id = c.order_id
	orders.erase(id)
	order_numbers.erase(id)

func has_orders():
	return not order_numbers.is_empty()

func get_order_count():
	return order_numbers.size()

func finished_order(item):
	var id = order_numbers.pop_front()
	orders[id].finish_order()
	orders.erase(id)
	self.money += 1

func _on_egg_action_pressed():
	cursor.toggle_place_eggs()
