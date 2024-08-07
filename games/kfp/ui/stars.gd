extends HBoxContainer

func _ready() -> void:
	KfpManager.stars_changed.connect(_update)
	_update()

func _update():
	for i in get_child_count():
		var enable = i < KfpManager.stars
		get_child(i).modulate = Color.WHITE if enable else Color.DIM_GRAY
