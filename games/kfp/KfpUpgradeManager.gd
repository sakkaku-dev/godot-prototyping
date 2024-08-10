extends Node

const FARM_SIZE = "FarmSize"
const EGG = "Egg"
const ORDER_DESK = "OrderDesk"
const TAKEOUT_DESK = "TakeoutDesk"
const CUTTING_BOARD = "CuttingBoard"
const RESTAURANT = "Restaurant"

const UPGRADES = [
	KfpUpgradeManager.EGG,
	KfpUpgradeManager.ORDER_DESK,
	KfpUpgradeManager.CUTTING_BOARD,
	KfpUpgradeManager.TAKEOUT_DESK,
	KfpUpgradeManager.FARM_SIZE,
	KfpUpgradeManager.RESTAURANT,
]

var upgrades = {}
var upgrade_count = {}

func _ready() -> void:
	var data = CSVParser.parse_csv("res://games/kfp/data/upgrades.csv")
	for item in data:
		if not item["type"] in upgrades:
			upgrades[item["type"]] = []

		upgrades[item["type"]].append(item)
	for arr in upgrades.values():
		arr.sort_custom(func(a, b): return int(a["price"]) < int(b["price"]))

func upgrade(type: String):
	if not type in upgrade_count:
		upgrade_count[type] = 0
	
	upgrade_count[type] += 1

func get_upgrade_count(type: String) -> int:
	if not type in upgrade_count:
		return 0
	return upgrade_count[type]

func has_last_upgrade(type: String) -> bool:
	return get_upgrade_count(type) >= upgrades[type].size()

func _get_current_upgrade(type: String) -> Dictionary:
	var idx = get_upgrade_count(type)
	if not type in upgrades:
		return {}
	if idx >= upgrades[type].size():
		idx = upgrades[type].size() - 1

	return upgrades[type][idx]

func get_upgrade_price(type: String) -> int:
	var upgrade = _get_current_upgrade(type)
	if upgrade.is_empty():
		return 0
	
	return int(upgrade["price"])

func get_upgrade_value(type: String) -> Variant:
	var upgrade = _get_current_upgrade(type)
	if upgrade.is_empty():
		return null
	
	return upgrade["value"]
