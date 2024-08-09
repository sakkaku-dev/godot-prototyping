extends Label

func _ready() -> void:
	KfpManager.farm_size_changed.connect(_update)
	KfpManager.eggs_changed.connect(_update)
	KfpManager.chicken_added.connect(func(_x, _y): _update())
	KfpManager.chicken_removed.connect(func(_x): _update())
	_update()

func _update() -> void:
	text = "%s / %s" % [KfpManager.get_total_chickens_in_farm(), KfpManager.max_farm_size]
