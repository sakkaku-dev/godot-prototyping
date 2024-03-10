extends Node2D

@export var pieces_scene: Array[PackedScene] = []
@export var piece_count := 4

@onready var tile_map = $TileMap
@onready var tile_map_highlight = $TileMapHighlight

var pressed = null
var pieces := {}

func _ready():
	var exclude := []
	
	for p in piece_count:
		var piece = pieces_scene.pick_random().instantiate()
		tile_map.add_child(piece)
		
		var tile = tile_map.random_tile(exclude)
		piece.global_position = tile_map.map_to_local(tile)
		piece.coord = tile
		piece.pressed.connect(func():
			pressed = piece
			tile_map_highlight.highlight_coords = piece.moveable_tiles(tile_map)
		)
		pieces[tile] = piece 
		
		exclude.append(tile)
		exclude.append_array(tile_map.get_neighbors(tile))

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		var coord = tile_map.local_to_map(get_global_mouse_position())
		if coord in pieces:
			var piece = pieces[coord]
			pressed = pieces
			tile_map_highlight.highlight_coords = piece.moveable_tiles(tile_map)
	elif event.is_action_pressed("cancel") and pressed:
		pressed = null
		tile_map_highlight.highlight_coords = []
