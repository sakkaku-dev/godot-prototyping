class_name Queue
extends Area2D

signal awaiting(has_customer)

@export var dir := Vector2.LEFT
@export var distance := 20

var customers := []

func _ready():
	body_entered.connect(func(b):
		if is_in_queue(b):
			awaiting.emit(true)
	)
	body_exited.connect(func(b):
		if is_in_queue(b):
			remove_customer(b)
	)

func queue_customer(customer: Customer):
	customers.append(customer)
	return global_position

func get_first_customer():
	if customers.is_empty(): return null
	return customers[0]

func remove_customer(c: Customer):
	customers.erase(c)
	print("Customer %s left and %s remaining" % [c, customers.size()])

func _get_position(pos: int):
	return global_position + dir * pos * distance

func has_customers():
	return not customers.is_empty()

func is_in_queue(customer: Customer):
	return customer in customers
