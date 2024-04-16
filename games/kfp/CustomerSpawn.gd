extends Node

@export var open_sign: Interactable

@export var timer: Timer
@export var spawner: Spawner2D
@export var move_order: Node2D
@export var exit_order: Node2D

func _ready():
	open_sign.interacted.connect(func(_a): open_restaurant())
	timer.timeout.connect(func(): _spawn_customer())

func _spawn_customer():
	var customer = spawner.spawn()
	customer.move_order = move_order
	customer.exit_order = exit_order

func open_restaurant():
	timer.start()

func close_restaurant():
	timer.stop()
