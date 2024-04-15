extends Node

@export var timer: Timer
@export var spawner: Spawner2D
@export var order_marker: Node2D
@export var order_marker_2: Node2D
@export var exit_marker: Node2D

func _ready():
	timer.timeout.connect(func(): _spawn_customer())

func _spawn_customer():
	var customer = spawner.spawn()
	customer.move_order.append(order_marker_2.global_position)
	customer.move_order.append(order_marker.global_position)
	customer.exit_order.push_front(exit_marker.global_position)

func open_restaurant():
	timer.start()

func close_restaurant():
	timer.stop()
