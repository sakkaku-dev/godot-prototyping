extends Sprite2D

@export var room: Room
@export var tile_map: TileMapLayer

var selected_button: RoomItemTile:
	set(v):
		if selected_button:
			selected_button.set_enabled(false)
		
		selected_button = v
		visible = v != null
		
		if selected_button:
			selected_button.set_enabled(true)
		
		if v != null:
			if room:
				room.highlight_area(v.placement)
		else:
			if room:
				room.reset_highlight()

func _ready() -> void:
	self.selected_button = null

func _get_count() -> int:
	return KfpManager.get_item_count(selected_button.count.item)

func _unhandled_input(event: InputEvent) -> void:
	if selected_button:
		if event.is_action_pressed("action"):
			if _get_count() > 0 and room.place_tile(selected_button, _current_coord()):
				KfpManager.use_item(selected_button.count.item)
				if _get_count() <= 0:
					self.selected_button = null
		elif event.is_action_pressed("erase"):
			var item = room.clear_tile(_current_coord())
			if item:
				KfpManager.add_item(item)
		elif event.is_action_pressed("ui_cancel"):
			self.selected_button = null
			get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if visible:
		global_position = _current_pos()

func _current_pos():
	return tile_map.map_to_local(_current_coord())

func _current_coord():
	return tile_map.local_to_map(get_global_mouse_position())

func _on_place_tile_item_tile_pressed(btn: RoomItemTile) -> void:
	self.selected_button = btn
