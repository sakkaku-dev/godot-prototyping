extends Node

signal chicken_added()
signal chicken_assigned(c)
signal order_received(id)
signal order_finished(id)

enum Traits {
	LAZY,
	DILIGENT,
}

var chickens := []
var assigned_chickens := []
var assigning_chicken: ChickenResource

var order_id := 0
var open_orders := []
var finished_orders := []

func add_random_chicken():
	var res = ChickenResource.new()
	res.traits = [Traits.values().pick_random()]
	chickens.append(res)
	chicken_added.emit(res)

func add_assigned_chicken():
	assigned_chickens.append(assigning_chicken)
	chicken_assigned.emit(assigning_chicken)
	assigning_chicken = null

func add_new_order():
	order_id += 1
	open_orders.append(order_id)
	order_received.emit(order_id)
	return order_id

func next_open_order() -> int:
	if open_orders.is_empty():
		return -1
	return open_orders[0]

func finish_order(id: int):
	open_orders.erase(id)
	finished_orders.append(id)
	order_finished.emit(id)
