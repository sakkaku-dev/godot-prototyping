extends RoomItemTile

func _ready() -> void:
	super._ready()
	KfpManager.eggs_changed.connect(func(): _update())
	buy.connect(func(res): KfpManager.buy_item(res))

func get_count():
	return KfpManager.eggs
