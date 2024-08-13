extends Button

func _ready() -> void:
	KfpManager.reputation_changed.connect(func(): _update())
	_update()

func _update():
	visible = KfpManager.reputation == 0
