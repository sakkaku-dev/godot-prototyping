extends Label

func _ready() -> void:
	KfpManager.money_changed.connect(_update)
	_update()

func _update():
	text = "$%s" % KfpManager.money
