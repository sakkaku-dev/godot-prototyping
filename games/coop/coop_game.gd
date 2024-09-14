extends Node3D

var shop_ui_tween: Tween
var shop_open := false:
	set(v):
		shop_open = v
		_update_moveable_objects()
		
		if shop_open:
			navigation_region_3d.bake_navigation_mesh()
			
			print("Opening Shop")
			customer_spawner.start_timer()
			shop_open_timer.start()
			
			shop_ui_tween = _create_tw(shop_ui_tween)
			shop_ui_tween.tween_property(shop_open_time, "position", Vector2.ZERO, 0.5).from(shop_open_time.size * Vector2.UP)
			shop_open_time.show()
		else:
			print("Closing Shop")
			
			shop_ui_tween = _create_tw(shop_ui_tween)
			shop_ui_tween.tween_property(shop_open_time, "position", shop_open_time.size * Vector2.UP, 0.5)
			shop_open_time.hide()
			reset_ready_state()

var ready_players := {}
var money := 0:
	set(v):
		money = v
		money_label.text = "%s" % money

@export var cashier: Cashier
@export var shop_open_time: Control
@export var money_label: Label

@onready var customer_spawner: CustomerSpawner = $CustomerSpawner
@onready var shop_open_timer: Timer = $ShopOpenTimer
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var grid_map: ShopGridMap = $NavigationRegion3D/GridMap

func _create_tw(prev_tw: Tween):
	if prev_tw and prev_tw.is_running():
		prev_tw.kill()
	
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _ready() -> void:
	InputMapper.override_key_inputs({
		"move_left": [KEY_A, InputMapper.joy_stick_x(-1)],
		"move_right": [KEY_D, InputMapper.joy_stick_x(1)],
		"move_up": [KEY_W, InputMapper.joy_stick_y(-1)],
		"move_down": [KEY_S, InputMapper.joy_stick_y(1)],
		"interact": [KEY_E, InputMapper.joy_btn(JOY_BUTTON_A)],
		"action": [KEY_SPACE, InputMapper.joy_btn(JOY_BUTTON_X)],
		"sprint": [KEY_SHIFT, InputMapper.joy_btn(JOY_BUTTON_B)],
		"accept": [KEY_CTRL, InputMapper.joy_btn(JOY_BUTTON_Y)],
	})
	
	shop_open = false
	money = 0
	
	shop_open_timer.timeout.connect(func():
		customer_spawner.stop_timer()
		_check_all_customers_left()
		print("Closing hours")
	)
	customer_spawner.customer_left.connect(func(c):
		if customer_spawner.is_stopped():
			_check_all_customers_left(c)
	)
	cashier.money_received.connect(func(m): money += m)
	grid_map.object_placed.connect(func(): _update_moveable_objects())
	
	for player in get_tree().get_nodes_in_group("player"):
		ready_players[player] = false
		player.accepted.connect(func():
			ready_players[player] = not ready_players[player]
			print("Ready players: %s" % ready_players.values())
			if is_everyone_ready():
				start_game()
		)

func is_everyone_ready():
	return ready_players.values().filter(func(x): return not x).is_empty()

func reset_ready_state():
	for x in ready_players:
		ready_players[x] = false

func start_game():
	shop_open = true

func _update_moveable_objects():
	for obj in get_tree().get_nodes_in_group("moveable"):
		obj.pickupable = not shop_open

func _reset_moveable_objects():
	for obj in get_tree().get_nodes_in_group("moveable"):
		obj.reset()

func _check_all_customers_left(current_customer: ShopCustomer = null):
	var customers = get_tree().get_nodes_in_group("customer").filter(func(c): return c != current_customer)
	if customers.is_empty():
		shop_open = false
