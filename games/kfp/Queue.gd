class_name Queue
extends Area2D

@export var dir := Vector2.LEFT
@export var distance := 20

var customers := []

func queue_customer(customer: Customer):
	var order_pos = customers.size()
	var pos = _get_position(order_pos)
	customers.append(customer)
	return global_position

func get_first_customer():
	if customers.is_empty(): return null
	return customers[0]

func processed_customer():
	customers.pop_front()

func _get_position(pos: int):
	return global_position + dir * pos * distance

func has_customers():
	return not customers.is_empty()
