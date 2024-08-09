extends Button

func _ready() -> void:
	hide()
	KfpManager.item_bought.connect(func(_x): _update())
	_update()
	
func _update():
	visible = KfpUpgradeManager.get_upgrade_count(KfpUpgradeManager.RESTAURANT) > 0
