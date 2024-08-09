extends Button

@export var label := "Buy"
@export var hide_if_disabled := false
@export var max_upgrade := -1
@export var parent: TilePlacement
@export_enum(
	KfpUpgradeManager.EGG,
	KfpUpgradeManager.ORDER_DESK,
	KfpUpgradeManager.CUTTING_BOARD,
	KfpUpgradeManager.TAKEOUT_DESK,
	KfpUpgradeManager.FARM_SIZE,
	KfpUpgradeManager.RESTAURANT,
) var item := KfpUpgradeManager.EGG

func _ready() -> void:
	if parent:
		hide()
		parent.changed_placing.connect(func(on): visible = on)
	
	pressed.connect(func(): KfpManager.buy_upgrade(item))
	KfpManager.item_bought.connect(func(_x): _update())
	_update()

func _update():
	var price = KfpUpgradeManager.get_upgrade_price(item)
	disabled = KfpManager.money < price
	text = "%s ($%s)" % [label, price]
	
	if hide_if_disabled:
		visible = not disabled

	if max_upgrade > 0:
		visible = KfpUpgradeManager.get_upgrade_count(item) < max_upgrade
		print(item, ", ", KfpUpgradeManager.get_upgrade_count(item))
