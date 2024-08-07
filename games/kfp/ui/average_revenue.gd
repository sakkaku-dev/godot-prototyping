extends Label

func _ready() -> void:
	KfpManager.average_revenue_changed.connect(_update)
	_update()
	
func _update():
	text = "$%s / day" % KfpManager.average_revenue
