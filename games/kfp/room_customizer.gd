class_name RoomCustomizer
extends Node2D

enum Tile {
	ROOM,
	INTERIOR,
	ORDER,
	TAKEOUT,
	WORKING,
}

var current_tile := Tile.ROOM
var pressed := false

var layers := {
	Tile.ROOM: 0,
	Tile.INTERIOR: 1,
}

@export var tile_button_container: Control

@onready var tile_map = $TileMap
@onready var color_rect = $TileMap/ColorRect

func _ready():
	for c in tile_button_container.get_children():
		c.pressed.connect(func():
			current_tile = c.tile
			print(Tile.keys()[current_tile])
		)

func _to_coord():
	return tile_map.local_to_map(get_global_mouse_position())

func _unhandled_input(event):
	if event.is_action_pressed("action") or event.is_action_pressed("secondary"):
		pressed = true
	elif event.is_action_released("action") or event.is_action_released("secondary"):
		pressed = false


func _process(delta):
	color_rect.global_position = tile_map.map_to_local(_to_coord()) - color_rect.size / 2

	if not pressed: return

	if Input.is_action_pressed("action"):
		match current_tile:
			Tile.ROOM: _place_room_tile()
			Tile.INTERIOR: _place_interior_tile()
	elif Input.is_action_pressed("secondary"):
		_remove_tile()
	
	
func _place_interior_tile():
	tile_map.set_cell(1, _to_coord(), 0, Vector2i(1, 1))

func _place_room_tile():
	tile_map.set_cell(0, _to_coord(), 0, Vector2i(1, 2))

func _remove_tile():
	tile_map.set_cell(layers[current_tile], _to_coord(), -1)
