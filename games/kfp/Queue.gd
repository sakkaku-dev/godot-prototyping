class_name Queue
extends Area2D

signal awaiting(has_customer)

@export var dir := Vector2.LEFT
@export var distance := 20

var customers := []

func queue_customer(customer: Customer):
	var order_pos = customers.size()
	var pos = _get_position(order_pos)
	customers.append(customer)
	
	awaiting.emit(has_customers())
	return global_position

func get_first_customer():
	if customers.is_empty(): return null
	return customers[0]

func processed_customer():
	customers.pop_front()
	awaiting.emit(has_customers())

func _get_position(pos: int):
	return global_position + dir * pos * distance

func has_customers():
	return not customers.is_empty()

func is_in_queue(customer: Customer):
	return customer in customers
