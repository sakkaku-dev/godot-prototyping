extends Label

@export var show_used := true

func _ready() -> void:
	KfpManager.chicken_assigned_changed.connect(func(_x): _update())
	KfpManager.chicken_added.connect(func(_x, _y): _update())
	KfpManager.chicken_removed.connect(func(_x): _update())
	_update()

func _update() -> void:
	text = ""
	if show_used:
		text += "%s / " % KfpManager.assigned_chickens.size()
	
	text += "%s" % KfpManager.chickens.size()
