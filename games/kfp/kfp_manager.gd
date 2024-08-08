extends Node

signal eggs_changed()
signal chicken_supply_changed()
signal money_changed()
signal order_desk_changed()
signal cutting_board_changed()
signal takeout_desk_changed()
signal stars_changed()
signal average_revenue_changed()
signal farm_size_changed()

signal chicken_removed(res)
signal chicken_added(res, pos)
signal chicken_assigned_changed(c)

signal order_received(id)
signal order_prepared(id)

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
var takeout_desks := 0:
	set(v): takeout_desks = v; takeout_desk_changed.emit()

var stars := 0:
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
var prepared_orders := []

func _ready() -> void:
	for i in range(10):
		add_random_chicken()

func add_random_chicken(pos = Vector2.ZERO):
	var res = ChickenResource.new()
	res.traits = [ChickenTraits.get_random_trait()]
	chickens.append(res)
	chicken_added.emit(res, pos)


########################
### Shop / Inventory ###
########################


func buy_item(item: ShopResource):
	if pay_item(item):
		add_item(item)
func add_item(item: ShopResource):
	match item.type:
		ShopResource.Item.ORDER_DESK: self.order_desks += 1
		ShopResource.Item.CUTTING_BOARD: self.cutting_boards += 1
		ShopResource.Item.TAKEOUT_DESK: self.takeout_desks += 1
		ShopResource.Item.EGG: self.eggs += 1
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
	chicken_assigned_changed.emit()
	assigning_chicken = null

func remove_assigned_chicken(res: ChickenResource):
	assigned_chickens.erase(res)
	chicken_assigned_changed.emit()

func add_new_order():
	order_id += 1
	open_orders.append(order_id)
	order_received.emit(order_id)
	return order_id

func next_open_order() -> int:
	if open_orders.is_empty():
		return -1
	return open_orders[0]

func prepared_food_for_order(id: int):
	open_orders.erase(id)
	prepared_orders.append(id)
	order_prepared.emit(id)

func is_order_ready_for_takeout(id: int):
	return id in prepared_orders

func finish_order(id: int):
	if not id in prepared_orders:
		print("Id %s is not prepared for takeout yet" % id)
		return false
	
	prepared_orders.erase(id)
	self.money += 10

func update_revenue(revenue: Array[int]):
	var avg = calculate_average(revenue)
	if average_revenue <= 0:
		self.average_revenue = avg
	else:
		self.average_revenue = add_averages(average_revenue, avg)

func update_reviews(reviews: Array[int]):
	var avg = calculate_average(reviews)
	if stars <= 0:
		self.stars = avg
	else:
		self.stars = add_averages(stars, avg)

func calculate_average(values: Array[int]):
	var sum = values.reduce(func(a, b): return a + b, 0.0)
	return sum / values.size()

func add_averages(avg1: float, avg2: float):
	var sum = avg1 + avg2
	return avg1/sum + avg2/sum

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
