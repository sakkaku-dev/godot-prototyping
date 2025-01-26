extends Node3D

var shop_ui_tween: Tween
var shop_open := false:
	set(v):
		shop_open = v
		_update_moveable_objects()
		
		if shop_open:
			#navigation_region_3d.bake_navigation_mesh()
			
			customer_spawner.start_timer()
			shop_open_timer.start()
			shop_time_effect.do_show()
			ready_effect.do_hide()
		else:
			print("Closing Shop")
			shop_time_effect.do_hide()
			ready_effect.do_show()
			player_spawner.shop_closed()
			
			#if was_open:
				#shop.open_shop()
				#was_open = false

@export var shop_open_time: Control
@export var money_label: Label

@onready var customer_spawner: CustomerSpawner = $CustomerSpawner
@onready var shop_open_timer: Timer = $ShopOpenTimer
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var grid_map: ShopGridMap = $NavigationRegion3D/GridMap
@onready var player_spawner: PlayerSpawner = $PlayerSpawner
@onready var ready_effect: SlideEffect = $ReadyEffect
@onready var shop_time_effect: SlideEffect = $ShopTimeEffect

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
		"dash": [KEY_SHIFT, InputMapper.joy_btn(JOY_BUTTON_B)],
		"accept": [KEY_CTRL, InputMapper.joy_btn(JOY_BUTTON_Y)],
	})
	
	shop_open = false
	shop_open_timer.timeout.connect(func():
		customer_spawner.stop_timer()
		_check_all_customers_left()
	)
	customer_spawner.customer_left.connect(func(c):
		if customer_spawner.is_stopped():
			_check_all_customers_left(c)
	)
	grid_map.object_placed.connect(func(): _update_moveable_objects())
	player_spawner.all_players_ready.connect(func(): start_game())

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
