extends Node

@export var timer: Timer
@export var spawner: Spawner2D
@export var order_marker: Node2D
@export var order_marker_2: Node2D

func _ready():
	timer.start()
	timer.timeout.connect(func(): _spawn_customer())

func _spawn_customer():
	var customer = spawner.spawn()
	customer.add_target(order_marker_2.global_position)
	customer.add_target(order_marker.global_position)
