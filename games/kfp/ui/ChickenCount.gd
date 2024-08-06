extends Label

func _ready() -> void:
	KfpManager.chicken_assigned.connect(func(_x): _update())
	KfpManager.chicken_added.connect(func(_x, _y): _update())
	KfpManager.chicken_removed.connect(func(_x): _update())
	_update()

func _update() -> void:
	text = "%s / %s" % [KfpManager.assigned_chickens.size(), KfpManager.chickens.size()]
