extends TextureButton

@export var label: Label

func _ready():
	KfpManager.chicken_supply_changed.connect(_update)
	_update()
	
func _update():
	label.text = "%s" % KfpManager.chicken_supply
