class_name BuyTextButton
extends Button

@export_enum(
	KfpUpgradeManager.EGG,
	KfpUpgradeManager.ORDER_DESK,
	KfpUpgradeManager.CUTTING_BOARD,
	KfpUpgradeManager.TAKEOUT_DESK,
	KfpUpgradeManager.FARM_SIZE,
	KfpUpgradeManager.RESTAURANT,
	KfpUpgradeManager.FARM_NEST,
	KfpUpgradeManager.BUTCHER_HOUSE,
) var item := KfpUpgradeManager.EGG

func _ready() -> void:
	pressed.connect(func(): KfpManager.buy_upgrade(item))
	KfpManager.money_changed.connect(func(): _update())
	KfpManager.items_changed.connect(func(_x): _update())
	_update()

func _update():
	var price = KfpUpgradeManager.get_upgrade_price(item)
	var currency = KfpManager.get_item_count(KfpUpgradeManager.EGG)
	var count = KfpUpgradeManager.get_upgrade_count(item)
	var prefix = "Buy" if count <= 0 else "Upgrade"
	
	text = "%s %s (%s)" % [prefix, tr(item), price]
	disabled = currency < price
	visible = not (count == 0 and disabled)
