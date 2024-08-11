extends Label

func _process(_d) -> void:
	_update()

func _update():
	text = "%.2f/s" % KfpManager.get_chicken_hatch_rate()
