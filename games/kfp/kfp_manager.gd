extends Node

signal chicken_supply_changed()
signal money_changed()
signal stars_changed()
signal average_revenue_changed()
signal farm_size_changed()
signal reputation_changed()

signal item_bought(item: String)
signal items_changed(item: String)

signal egg_placed()
signal egg_hatched(coord: Vector2i)

signal chicken_removed(res)
signal chicken_added(res, pos)
signal chicken_assigned_changed(res: ChickenResource)
signal chicken_changed()

signal order_received(id)
signal order_prepared(id)

var chicken_supply := 0:
	set(v): chicken_supply = v; chicken_supply_changed.emit()
var money := 100:
	set(v): money = v; money_changed.emit()

var stars := 0:
	set(v): stars = v; stars_changed.emit()
var average_revenue := 0.0:
	set(v): average_revenue = v; average_revenue_changed.emit()
var max_farm_size := 0:
	set(v): max_farm_size = v; farm_size_changed.emit()
var reputation := 0.0:
	set(v): reputation = v; reputation_changed.emit()

var initial_reputation := .1
var reputation_change_rate := 0.5
var chicken_hatch_rate := 1.0

var used_chickens := {}
var farm_items := {}
var hatching_eggs := {}
var chickens := []
var assigned_chickens := []
var assigning_chicken: ChickenResource

var open_orders := []
var prepared_orders := []
var order_id := 0
var chicken_id := 0

var items = {}

func _ready() -> void:
	for i in range(0):
		add_random_chicken()
	
	chicken_added.connect(func(_x, _y): chicken_changed.emit())
	chicken_removed.connect(func(_x): chicken_changed.emit())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		print("Chickens: %s, Used: , Hatching: " % [chickens.size(), used_chickens.size(), hatching_eggs.size()])

func add_random_chicken(pos = Vector2.ZERO):
	chicken_id += 1
	var res = ChickenResource.new()
	res.name = "Chicken %s" % chicken_id
	res.traits = [ChickenTraits.get_random_trait()]
	chickens.append(res)
	chicken_added.emit(res, pos)


########################
### Shop / Inventory ###
########################

func buy_upgrade(item: String):
	var price = KfpUpgradeManager.get_upgrade_price(item)
	if pay_item(price):
		add_item(item)
		KfpUpgradeManager.upgrade(item)
		item_bought.emit(item)
	
func buy_item(item: ShopResource):
	if pay_item(item.price):
		add_item(item.map_to_upgrade())

func add_item(type: String, amount = 1):
	if type == KfpUpgradeManager.FARM_SIZE:
		self.max_farm_size = int(KfpUpgradeManager.get_upgrade_value(type))
		return
	
	if not type in items:
		items[type] = 0
	
	items[type] += amount
	items_changed.emit(type)

func pay_item(price: int):
	if price > money:
		print("Not enough money to buy item: %s" % price)
		return false

	self.money -= price
	return true

func use_item(type: String):
	if get_item_count(type) <= 0:
		print("No item %s" % type)
		return false
	
	items[type] -= 1
	items_changed.emit(type)
	print("used item %s, remaining %s" % [type, items[type]])
	return true

func get_item_count(type: String):
	if not type in items: return 0
	return items[type]

func sell_supply(price: int):
	if chicken_supply <= 0:
		print("No supply to sell")
		return
	
	self.chicken_supply -= 1
	self.money += price

##################
### Restaurant ###
##################

func has_supply_left():
	var all_orders = open_orders.size() + prepared_orders.size()
	return chicken_supply - all_orders > 0

func add_assigned_chicken():
	assigned_chickens.append(assigning_chicken)
	chicken_assigned_changed.emit(assigning_chicken)
	assigning_chicken = null

func remove_assigned_chicken(res: ChickenResource):
	assigned_chickens.erase(res)
	chicken_assigned_changed.emit(res)

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
	self.chicken_supply -= 1
	self.money += randi_range(20, 30)
	self.reputation *= 1 + reputation_change_rate

func failed_order(id: int):
	open_orders.erase(id)
	prepared_orders.erase(id)
	self.reputation *= 1 - reputation_change_rate

func open_restaurant():
	self.reputation = initial_reputation

func get_customers_per_second():
	return reputation

func update_revenue(revenue: Array[int]):
	var sum = revenue.reduce(func(a, b): return a + b, 0.0)
	if average_revenue <= 0:
		self.average_revenue = sum
	else:
		self.average_revenue = add_averages(average_revenue, sum)

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
	return (avg1 + avg2) / 2.

############
### Farm ###
############

func get_available_chickens():
	return chickens.filter(func(c): return not c in used_chickens)

func use_chicken_for(chicken: ChickenResource, coord: Vector2i):
	if chicken in used_chickens:
		print("Chicken %s is already used at %s" % [chicken, used_chickens[chicken]])
		return
	used_chickens[chicken] = coord

func butcher_chicken(res: ChickenResource):
	if not res in chickens:
		print("Chicken does not exist or already has been butchered")
		return
	
	chickens.erase(res)
	chicken_removed.emit(res)
	self.chicken_supply += randi_range(2, 5)

func get_total_chickens_in_farm():
	return chickens.size() + hatching_eggs.size()

func is_farm_full():
	return get_total_chickens_in_farm() >= max_farm_size

func hatch_egg(coord: Vector2i, pos = Vector2.ZERO):
	if not coord in hatching_eggs:
		print("No egg hatching at %s" % coord)
		return false
	
	hatching_eggs.erase(coord)
	add_random_chicken(pos)
	egg_hatched.emit(coord)
	return true

func get_farm_item(coord: Vector2i) -> String:
	if not coord in farm_items: return ""
	return farm_items[coord]

func place_farm_item(coord: Vector2i, type: String):
	if coord in farm_items:
		print("Item %s is already at %s. Cannot place %s" % [farm_items[coord], coord, type])
		return false
	
	farm_items[coord] = type
	return true

func start_hatching(coord: Vector2i, value: float):
	hatching_eggs[coord] = value
	egg_placed.emit()
	
func get_chicken_hatch_rate():
	if chickens.is_empty(): return 0.0
	return (log(chickens.size() * 2) / log(2)) + 1

func get_chicken_egg_drop_rate():
	if chickens.is_empty(): return 0.0
	return max(((log(chickens.size()) / log(2)) + 0.05)  * 0.05, 0.01)
