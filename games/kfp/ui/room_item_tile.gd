class_name RoomItemTile
extends ShopItem

@export var source_id := 0
@export var item_id := 0
@export var placement := Room.Placement.WORK_AREA

func _ready() -> void:
	super._ready()
	_update()

func _update():
	var count = get_count()
	count_label.show()
	count_label.text = "%sx" % count
	modulate = Color.WHITE if count > 0 else Color.DIM_GRAY
	disabled = count <= 0

func get_count():
	return 0
	
func use_item():
	pass
