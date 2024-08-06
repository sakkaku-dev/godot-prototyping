class_name RoomItemTile
extends TextureButton

@export var source_id := 0
@export var item_id := 0
@export var placement := Room.Placement.WORK_AREA
@export var shop_item: ShopResource

@export var label: Label
@export var count_label: Label
@export var texture: TextureRect

func _ready() -> void:
	if shop_item:
		label.text = "%s" % shop_item.name
		texture.texture = shop_item.sprite
	
	_update()

func _update():
	var count = get_count()
	count_label.text = "%sx" % count
	modulate = Color.WHITE if count > 0 else Color.DIM_GRAY
	disabled = count <= 0

func get_count():
	return 0
	
func use_item():
	pass
