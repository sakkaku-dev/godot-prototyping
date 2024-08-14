extends Node

const FARM_SIZE = "FarmSize"
const EGG = "Egg"
const ORDER_DESK = "OrderDesk"
const TAKEOUT_DESK = "TakeoutDesk"
const CUTTING_BOARD = "CuttingBoard"
const RESTAURANT = "Restaurant"
const FARM_NEST = "FarmNest"
const BUTCHER_HOUSE = "ButcherHouse"
const CHICKEN = "Chicken"

var value_fn = {
	FARM_SIZE: func(idx): return 5 * idx + 5,
}

var cost_fn = {
	FARM_SIZE: func(idx): return 50 * 2 ** idx,
}

@export var restaurant_base_price := 50
@export var restaurant_price_growth := 1.1

# var upgrades = {}
var upgrade_count = {}

# func _ready() -> void:
# 	var data = CSVParser.parse_csv("res://games/kfp/data/upgrades.csv")
# 	for item in data:
# 		if not item["type"] in upgrades:
# 			upgrades[item["type"]] = []

# 		upgrades[item["type"]].append(item)
# 	for arr in upgrades.values():
# 		arr.sort_custom(func(a, b): return int(a["price"]) < int(b["price"]))

func upgrade(type: String):
	if not type in upgrade_count:
		upgrade_count[type] = 0
	
	upgrade_count[type] += 1

func get_upgrade_count(type: String) -> int:
	if not type in upgrade_count:
		return 0
	return upgrade_count[type]

# func has_last_upgrade(type: String) -> bool:
# 	return get_upgrade_count(type) >= upgrades[type].size()

# func get_upgrade(type: String, idx: int) -> Dictionary:
# 	# if not type in upgrades:
# 	# 	return {}
# 	# if idx >= upgrades[type].size():
# 	# 	idx = upgrades[type].size() - 1
# 	return upgrades[type][idx]

func get_upgrade_price(type: String, idx = get_upgrade_count(type)) -> int:
	if not type in cost_fn: return 0
	return cost_fn[type].call(idx)
	# var upgrade = get_upgrade(type, idx)
	# if upgrade.is_empty():
	# 	return 0
	
	# return int(upgrade["price"])

func get_upgrade_value(type: String, idx = get_upgrade_count(type)) -> Variant:
	return value_fn[type].call(idx)
	# var upgrade = get_upgrade(type, idx)
	# if upgrade.is_empty():
	# 	return null
	
	# return upgrade["value"]
