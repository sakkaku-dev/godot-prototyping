extends Label

@export var show_used := true

func _ready() -> void:
	KfpManager.chicken_assigned_changed.connect(func(_x): _update())
	KfpManager.chicken_changed.connect(func(): _update())
	_update()

func _update() -> void:
	text = ""
	if show_used:
		text += "%s / " % KfpManager.assigned_chickens.size()
	
	text += "%s" % KfpManager.chickens.size()
