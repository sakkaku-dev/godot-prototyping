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
		child.pressed.connect(func(): self.selected_button = child)

func _unhandled_input(event: InputEvent) -> void:
	if selected_button:
		if event.is_action_pressed("action"):
			if room.place_tile(selected_button, _current_coord()):
				pass # TODO: remove item from inventory
		elif event.is_action_pressed("erase"):
			room.clear_tile(_current_coord())
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
