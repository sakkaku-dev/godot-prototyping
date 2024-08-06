extends Label

func _ready():
	KfpManager.chicken_supply_changed.connect(_update)
	_update()
	
func _update():
	text = "%s" % KfpManager.chicken_supply
