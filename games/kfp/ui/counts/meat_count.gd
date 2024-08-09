extends Label

@export var container: Control

func _ready():
	KfpManager.chicken_supply_changed.connect(_update)
	_update()
	
func _update():
	if container:
		container.visible = KfpManager.chicken_supply > 0
	text = "%s" % KfpManager.chicken_supply
