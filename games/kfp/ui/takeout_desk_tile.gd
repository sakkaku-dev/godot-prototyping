extends RoomItemTile

func _ready() -> void:
	super._ready()
	buy.connect(func(res): KfpManager.buy_takeout_desk(res))
	KfpManager.takeout_desk_changed.connect(func(): _update())

func get_count():
	return KfpManager.takeout_desks
	
func use_item():
	KfpManager.takeout_desks -= 1
