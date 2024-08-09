class_name ShopResource
extends Resource

enum Item {
	EGG,
	CUTTING_BOARD,
	ORDER_DESK,
	TAKEOUT_DESK,
	LAYOUT,
	FARM_SIZE,
}

const UPGRADE_MAP = {
	Item.EGG: KfpUpgradeManager.EGG,
	Item.CUTTING_BOARD: KfpUpgradeManager.CUTTING_BOARD,
	Item.ORDER_DESK: KfpUpgradeManager.ORDER_DESK,
	Item.TAKEOUT_DESK: KfpUpgradeManager.TAKEOUT_DESK,
	Item.FARM_SIZE: KfpUpgradeManager.FARM_SIZE,
}

@export var type := Item.EGG
@export var name := ""
@export var sprite: Texture2D
@export var price := 100

func map_to_upgrade() -> String:
	return UPGRADE_MAP[type]
