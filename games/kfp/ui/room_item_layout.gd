class_name RoomItemLayout
extends Control

@export var item_button_container: Control
@export var placeholder: Sprite2D
@export var room: Room

var selected_button: RoomItemTile:
	set(v):
		selected_button = v
		placeholder.visible = v != null
		
		if v != null:
			room.highlight_area(v.placement)
		else:
			room.reset_highlight()

func _ready() -> void:
	self.selected_button = null
	
	for child in item_button_container.get_children():
		if child is RoomItemTile:
			child.pressed.connect(func(): self.selected_button = child)

func _find_button_for_item(item_id: int):
	for child in item_button_container.get_children():
		if child is RoomItemTile and child.item_id == item_id:
			return child
	return null

func _unhandled_input(event: InputEvent) -> void:
	if selected_button:
		if event.is_action_pressed("action"):
			if selected_button.get_count() > 0 and room.place_tile(selected_button, _current_coord()):
				selected_button.use_item()
				if selected_button.get_count() <= 0:
					self.selected_button = null
		elif event.is_action_pressed("erase"):
			var item = room.clear_tile(_current_coord())
			if item >= 0:
				var btn = _find_button_for_item(item)
				if btn:
					KfpManager.add_item(btn.shop_item)
				else:
					print("Cannot find button for item_id %s" % item)
		elif event.is_action_pressed("ui_cancel"):
			self.selected_button = null
			get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if placeholder.visible:
		placeholder.global_position = _current_pos()

func _current_pos():
	return room.floor_tiles.map_to_local(_current_coord())

func _current_coord():
	return room.floor_tiles.local_to_map(room.get_global_mouse_position())
