extends RoomItemTile

func _ready() -> void:
	super._ready()
	KfpManager.cutting_board_changed.connect(func(): _update())

func get_count():
	return KfpManager.cutting_boards
	
func use_item():
	KfpManager.cutting_boards -= 1
