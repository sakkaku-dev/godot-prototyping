extends Button

@export var label := "Buy"
@export var hide_if_disabled := false
@export var disable_on_last := false
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
	KfpManager.money_changed.connect(func(): _update())
	KfpManager.item_bought.connect(func(): _update())
	_update()

func _update():
	var price = KfpUpgradeManager.get_upgrade_price(item)
	disabled = KfpManager.money < price
	text = "%s ($%s)" % [label, price]

	if disable_on_last:
		disabled = KfpUpgradeManager.has_last_upgrade(item)
		text = "Fully Upgraded" if disabled else text
	
	if hide_if_disabled:
		visible = not disabled

	if max_upgrade > 0 and visible:
		visible = KfpUpgradeManager.get_upgrade_count(item) < max_upgrade
