class_name RoomItemTile
extends BaseButton

signal changed_placing(placing: bool)
signal item_tile_pressed(btn: RoomItemTile)

@export var placeholder: TilePlaceholder
@export var texture: Texture2D
@export var placement := Room.Placement.WORK_AREA
@export var count: ItemCount

func _ready() -> void:
	if placeholder:
		item_tile_pressed.connect(func(btn): placeholder._on_place_tile_item_tile_pressed(btn))
	pressed.connect(func(): item_tile_pressed.emit(self))
	
func set_enabled(on: bool):
	changed_placing.emit(on)
