class_name Restaurant
extends Node2D

signal move_to_farm()

const RESTAURANT_UPGRADES = [
	"res://games/kfp/rooms/room_000.tscn",
	"res://games/kfp/rooms/room_001.tscn",
	"res://games/kfp/rooms/room_003.tscn"
]

@export var customer_scene: PackedScene
@export var opened_ui: Control
@export var closed_ui: Control
@export var report: DailyReport

@export_category("Customer")
@export var initial_customer_value := 1.0
@onready var customer_value := initial_customer_value:
	set(v):
		customer_value = clamp(v, 0, initial_customer_value)
		if customer_value <= 0:
			_spawn_customer()
			customer_value = initial_customer_value

@onready var restaurant_placeholder: TilePlaceholder = $RestaurantPlaceholder
@onready var canvas_layer: CanvasLayer = $CanvasLayer
#@onready var customer_timer: Timer = $CustomerTimer
#@onready var day_timer: Timer = $DayTimer

var current_revenue: Array[int] = []
var current_reviews: Array[int] = []
var room: Room

func _ready() -> void:
	KfpManager.item_bought.connect(func(item): if item == KfpUpgradeManager.RESTAURANT: _update_restaurant())
		
	#customer_timer.timeout.connect(_spawn_customer)
	#day_timer.timeout.connect(_day_ended)
	_show_buttons()

func _update_restaurant():
	var idx = KfpManager.get_item_count(KfpUpgradeManager.RESTAURANT) - 1
	if idx >= 0:
		if is_instance_valid(room):
			room.queue_free()
		
		var node = load(RESTAURANT_UPGRADES[idx]).instantiate()
		add_child(node)
		room = node
		
		restaurant_placeholder.room = room

func _process(delta: float) -> void:
	self.customer_value -= delta * KfpManager.reputation

func _on_farm_button_pressed() -> void:
	move_to_farm.emit()

#func _day_ended():
	#customer_timer.stop()
	#_check_if_no_customers_left()
#
#func _check_if_no_customers_left(exclude: Customer = null):
	#if get_tree().get_nodes_in_group(Customer.GROUP).filter(func(c): return c != exclude).size() == 0:
		#_report_day()

func _show_buttons(closed = true):
	opened_ui.visible = not closed
	closed_ui.visible = closed

#func _report_day():
	#customer_timer.stop()
	#report.open(current_revenue, current_reviews)
	#KfpManager.update_reviews(current_reviews)
	#KfpManager.update_revenue(current_revenue)
	#
	#_show_buttons()

func _spawn_customer():
	var node = customer_scene.instantiate() as Customer
	node.order_failed.connect(func(): KfpManager.failed_order(node.order_id))
	node.order_completed.connect(func(id):
		KfpManager.finish_order(id)
		#current_revenue.append(5)
		#current_reviews.append([4, 4, 4, 3].pick_random())
	)
	#node.removed.connect(func(): _check_if_no_customers_left(node))
	add_child(node)

func _on_start_button_pressed():
	#day_timer.start()
	#customer_timer.random_start()
	KfpManager.open_restaurant()
	#_show_buttons(false)

#func _on_end_button_pressed() -> void:
	#day_timer.stop()
	#_day_ended()

func _on_assign_chicken_assign_chicken(chicken):
	KfpManager.assigning_chicken = chicken
