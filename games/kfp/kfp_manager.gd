extends Node

signal eggs_changed()
signal chicken_supply_changed()
signal money_changed()
signal order_desk_changed()
signal cutting_board_changed()
signal stars_changed()
signal average_revenue_changed()
signal farm_size_changed()

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
	set(v): chicken_supply = v; chicken_supply_changed.emit()
var eggs := 0:
	set(v): eggs = v; eggs_changed.emit()
var money := 1000:
	set(v): money = v; money_changed.emit()
var order_desks := 0:
	set(v): order_desks = v; order_desk_changed.emit()
var cutting_boards := 0:
	set(v): cutting_boards = v; cutting_board_changed.emit()

var stars := -1:
	set(v): stars = v; stars_changed.emit()
var average_revenue := 0.0:
	set(v): average_revenue = v; average_revenue_changed.emit()
var max_farm_size := 20:
	set(v): max_farm_size = v; farm_size_changed.emit()

var hatching_eggs := []
var chickens := []
var assigned_chickens := []
var assigning_chicken: ChickenResource

var order_id := 0
var open_orders := []
var finished_orders := []

func _ready() -> void:
	for i in range(10):
		add_random_chicken()

func add_random_chicken(pos = Vector2.ZERO):
	var res = ChickenResource.new()
	res.traits = [Traits.values().pick_random()]
	chickens.append(res)
	chicken_added.emit(res, pos)

############
### Shop ###
############

func buy_egg(item: ShopResource): if pay_item(item): self.eggs += 1
func buy_order_desk(item: ShopResource): if pay_item(item): self.order_desks += 1
func buy_cutting_board(item: ShopResource): if pay_item(item): self.cutting_boards += 1
func pay_item(item: ShopResource):
	if item.price > money:
		print("Not enough money to buy egg: %s" % item.resource_path)
		return false

	self.money -= item.price
	return true


##################
### Restaurant ###
##################

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

func update_revenue(revenue: Array[int]):
	var avg = calculate_average(revenue)
	self.average_revenue = (average_revenue + avg) / 2.

func update_reviews(reviews: Array[int]):
	var avg = calculate_average(reviews)
	if stars < 0:
		self.stars = avg
	else:
		self.stars = (stars + avg) / 2.

func calculate_average(values: Array[int]):
	var sum = values.reduce(func(a, b): return a + b, 0.0)
	return sum / values.size()


############
### Farm ###
############

func butcher_chicken(res: ChickenResource):
	if not res in chickens:
		print("Chicken does not exist or already has been butchered")
		return
	
	chickens.erase(res)
	chicken_removed.emit(res)
	self.chicken_supply += randi_range(2, 5)

func is_farm_full():
	return (chickens.size() + hatching_eggs.size()) >= max_farm_size

func hatch_egg(pos = Vector2.ZERO):
	if hatching_eggs.is_empty():
		print("No eggs are currently hatching")
		return
	
	add_random_chicken(pos)
	hatching_eggs.remove_at(0)

func placed_egg():
	if eggs <= 0:
		print("NO EGGS")
		return false
	if is_farm_full():
		print("NO SPACE")
		return false
	
	hatching_eggs.append(0)
	self.eggs -= 1
	return true
