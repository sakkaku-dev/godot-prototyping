class_name ItemCount
extends Label

@export_enum(
	KfpUpgradeManager.EGG,
	KfpUpgradeManager.ORDER_DESK,
	KfpUpgradeManager.CUTTING_BOARD,
	KfpUpgradeManager.TAKEOUT_DESK,
	KfpUpgradeManager.FARM_SIZE,
	KfpUpgradeManager.RESTAURANT,
	KfpUpgradeManager.FARM_NEST,
	KfpUpgradeManager.BUTCHER_HOUSE,
) var item: String

func _ready() -> void:
	KfpManager.items_changed.connect(func(type): if item == type: _update())
	_update()

func _update():
	text = "%s" % KfpManager.get_item_count(item)
