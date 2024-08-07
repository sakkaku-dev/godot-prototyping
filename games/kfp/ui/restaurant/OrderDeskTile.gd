extends RoomItemTile

func _ready() -> void:
	super._ready()
	buy.connect(func(res): KfpManager.buy_item(res))
	KfpManager.order_desk_changed.connect(func(): _update())

func get_count():
	return KfpManager.order_desks
	
func use_item():
	KfpManager.order_desks -= 1
