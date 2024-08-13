extends Label

@export var parent: Control

func _process(_d) -> void:
	_update()
	parent.visible = KfpManager.get_customers_per_second() > 0

func _update():
	text = "%.2f/s" % KfpManager.get_customers_per_second()
