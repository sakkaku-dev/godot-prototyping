class_name CustomerSpawner
extends Node3D

signal customer_left(c)

@export var scene: PackedScene
@onready var random_timer: RandomTimer = $RandomTimer

func _ready() -> void:
	random_timer.timeout.connect(func(): spawn())

func start_timer():
	random_timer.start()

func stop_timer():
	random_timer.stop()

func is_stopped():
	return random_timer.is_stopped()

func spawn():
	var customer = scene.instantiate()
	add_child(customer)
	customer.has_left.connect(func(): customer_left.emit(customer))
	
	var cashier = get_tree().get_first_node_in_group("cashier")
	var target = cashier.add_to_queue(customer)
	customer.move_to(target)
	customer.return_pos = global_position
	
