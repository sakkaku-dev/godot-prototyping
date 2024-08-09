extends Label

@export var container: Control

func _ready():
	KfpManager.eggs_changed.connect(_update)
	_update()
	
func _update():
	if container:
		container.visible = KfpManager.eggs > 0
	text = "%s" % KfpManager.eggs
