extends Button

@export var parent: TilePlacement
@export_enum(
	KfpUpgradeManager.EGG,
	KfpUpgradeManager.ORDER_DESK,
	KfpUpgradeManager.CUTTING_BOARD,
	KfpUpgradeManager.TAKEOUT_DESK,
	KfpUpgradeManager.FARM_SIZE,
) var item := KfpUpgradeManager.EGG

func _ready() -> void:
	hide()
	parent.changed_placing.connect(func(on): visible = on)
	pressed.connect(func(): KfpManager.buy_upgrade(item))
	KfpManager.money_changed.connect(func(): _update())
	_update()

func _update():
	var price = KfpUpgradeManager.get_upgrade_price(item)
	disabled = KfpManager.money < price
	text = "Buy($%s)" % price
