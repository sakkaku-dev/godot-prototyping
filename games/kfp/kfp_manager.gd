extends Node

signal eggs_changed()
signal chicken_supply_changed()

signal chicken_removed(res)
signal chicken_added(res, pos)
signal chicken_assigned(c)

signal order_received(id)
signal order_finished(id)

enum Traits {
	LAZY,
	DILIGENT,
	PERFECTIONIST,
	SLOPPY,
	CHARMING,
	NERVOUS,
	TEAM_PLAYER,
}

var chicken_supply := 0:
	set(v):
		chicken_supply = v
		chicken_supply_changed.emit()
		
var eggs := 0:
	set(v):
		eggs = v
		eggs_changed.emit()

var chickens := []
var assigned_chickens := []
var assigning_chicken: ChickenResource

var order_id := 0
var open_orders := []
var finished_orders := []

func butcher_chicken(res: ChickenResource):
	if not res in chickens:
		print("Chicken does not exist or already has been butchered")
		return
	
	chickens.erase(res)
	chicken_removed.emit(res)
	self.chicken_supply += randi_range(2, 5)

func add_random_chicken(pos = Vector2.ZERO):
	var res = ChickenResource.new()
	res.traits = [Traits.values().pick_random()]
	chickens.append(res)
	chicken_added.emit(res, pos)

func add_assigned_chicken():
	assigned_chickens.append(assigning_chicken)
	chicken_assigned.emit(assigning_chicken)
	assigning_chicken = null

func add_new_order():
	order_id += 1
	open_orders.append(order_id)
	order_received.emit(order_id)
	return order_id

func buy_egg():
	self.eggs += 1

func placed_egg():
	if eggs <= 0: return false
	self.eggs -= 1
	return true

func next_open_order() -> int:
	if open_orders.is_empty():
		return -1
	return open_orders[0]

func finish_order(id: int):
	open_orders.erase(id)
	finished_orders.append(id)
	order_finished.emit(id)