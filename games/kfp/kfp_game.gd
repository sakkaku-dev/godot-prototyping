extends Node2D

const RESTAURANT_UPGRADES = [
	"res://games/kfp/rooms/room_000.tscn",
	"res://games/kfp/rooms/room_001.tscn",
	"res://games/kfp/rooms/room_003.tscn"
]

@export var customer_scene: PackedScene
@export var opened_ui: Control
@export var closed_ui: Control
@export var report: DailyReport

@onready var day_timer: Timer = $DayTimer
@onready var restaurant_placeholder: Sprite2D = $RestaurantPlaceholder

@onready var customer_timer = $CustomerTimer
@onready var customer_spawn: Node2D = get_tree().get_first_node_in_group("spawn")

var current_revenue: Array[int] = []
var current_reviews: Array[int] = []

func _ready():
	KfpManager.assigned_chickens = []
	
	var idx = KfpUpgradeManager.get_upgrade_count(KfpUpgradeManager.RESTAURANT) - 1
	if idx >= 0:
		var node = load(RESTAURANT_UPGRADES[idx]).instantiate()
		add_child(node)
		restaurant_placeholder.room = node
	
	customer_timer.timeout.connect(_spawn_customer)
	day_timer.timeout.connect(_day_ended)
	_show_buttons()

func _day_ended():
	customer_timer.stop()
	_check_if_no_customers_left()

func _check_if_no_customers_left(exclude: Customer = null):
	if get_tree().get_nodes_in_group(Customer.GROUP).filter(func(c): return c != exclude).size() == 0:
		_report_day()

func _show_buttons(closed = true):
	opened_ui.visible = not closed
	closed_ui.visible = closed

func _report_day():
	report.open(current_revenue, current_reviews)
	KfpManager.update_reviews(current_reviews)
	KfpManager.update_revenue(current_revenue)
	
	_show_buttons()

func _spawn_customer():
	var node = customer_scene.instantiate() as Customer
	node.global_position = customer_spawn.global_position
	node.order_failed.connect(func(): current_reviews.append(1))
	node.order_completed.connect(func(id):
		KfpManager.finish_order(id)
		current_revenue.append(5)
		current_reviews.append([4, 4, 4, 3].pick_random())
	)
	node.removed.connect(func(): _check_if_no_customers_left(node))
	add_child(node)

func _on_start_button_pressed():
	day_timer.start()
	customer_timer.random_start()
	_show_buttons(false)

func _on_end_button_pressed() -> void:
	day_timer.stop()
	_day_ended()

func _on_farm_button_pressed():
	get_tree().change_scene_to_file("res://games/kfp/rooms/farm.tscn")

func _on_assign_chicken_assign_chicken(chicken):
	KfpManager.assigning_chicken = chicken

func _on_order_desk_buy(res: ShopResource) -> void:
	KfpManager.buy_order_desk(res)

func _on_cutting_board_buy(res: ShopResource) -> void:
	KfpManager.buy_cutting_board(res)
