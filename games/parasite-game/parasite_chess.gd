extends Node2D

@export var pieces_scene: Array[PackedScene] = []
@export var piece_count := 4

@export var move_color := Color.BLUE
@export var attack_color := Color.RED
@export var jump_color := Color.GREEN
@export var standby_color := Color.GRAY
@export var action_used_color := Color.DARK_GRAY

@onready var tile_map = $TileMap
@onready var tile_map_highlight = $TileMapHighlight
@onready var cursor = $Cursor

var initial_infect := false
var is_executing := false
var pressed = null
var pieces := {}

var actions := {}
var current_action

func _ready():
	var exclude := []
	
	for c in tile_map.get_used_cells(tile_map.layer):
		pieces[c] = null
	
	for i in piece_count:
		var piece = pieces_scene.pick_random().instantiate()
		tile_map.add_child(piece)
		
		if i == 0:
			piece.set_colors(move_color, attack_color, jump_color, standby_color)
		
		var tile = tile_map.random_tile(exclude)
		piece.global_position = tile_map.map_to_local(tile)
		piece.coord = tile
		piece.id = i
		piece.do_action.connect(func(a): _start_action_select(a, piece))
		pieces[tile] = piece 
		
		exclude.append(tile)
		exclude.append_array(tile_map.get_neighbors(tile))

func _update_actions():
	for p in pieces.values():
		if p == null: continue
		
		p.modulate = action_used_color if p.id in actions else Color.WHITE
		
func _execute_actions():
	is_executing = true
	for p in pieces.values():
		if p == null: continue
		
		if p.id in actions:
			var data = actions[p.id]
			
			if data.action == ParasitePiece.Action.MOVE:
				await _move_active(p, data.coord)
				_clear_action(p.id)
			elif data.action == ParasitePiece.Action.ATTACK:
				p.attack(tile_map.map_to_local(data.coord))
			elif data.action == ParasitePiece.Action.JUMP:
				p.jump_to(tile_map.map_to_local(data.coord))
			elif data.action == ParasitePiece.Action.STANDBY:
				_clear_action(p.id)

func _clear_action(id):
	actions.erase(id)
	if actions.size() == 0:
		is_executing = false
		print("Finished actions")
	
	_update_actions()

func _add_action(id, data):
	actions[id] = data
	if _get_remaining_infected().is_empty():
		print("All infected moved. Executing actions")
		_execute_actions()

func _get_remaining_infected():
	var infected = []
	for p in pieces.values():
		if p and p.infected and not p.id in actions:
			infected.append(p)
	return infected

func _start_action_select(a, p):
	current_action = a
	
	# Match doesn't seem to work
	if current_action == ParasitePiece.Action.MOVE:
		_show_moves(p, move_color)
	elif current_action == ParasitePiece.Action.ATTACK:
		_show_attacks(p, attack_color)
	elif current_action == ParasitePiece.Action.JUMP:
		_show_jump(p, jump_color)
	elif current_action == ParasitePiece.Action.STANDBY:
		_add_action(p.id, {"action": a, "coord": Vector2i.ZERO})
		_cancel_piece()
	else:
		print("Invalid action")

func _show_moves(p: ParasitePiece, c: Color):
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.moveable_tiles(tile_map)
func _show_attacks(p: ParasitePiece, c: Color):
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.attackable_tiles(tile_map)
func _show_jump(p: ParasitePiece, c: Color):
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.jumpable_tiles(tile_map)

func _unhandled_input(event):
	var coord = tile_map.local_to_map(get_global_mouse_position())
	
	if event is InputEventMouseMotion:
		if tile_map.has_value(coord):
			cursor.global_position = tile_map.map_to_local(coord) - cursor.size/2
	
	if event.is_action_pressed("action") and not initial_infect and coord in pieces:
		var p = pieces[coord]
		if p:
			initial_infect = true
			p.infected = true
			return
	
	if is_executing: return
	
	if event.is_action_pressed("action"):
		if not coord in pieces:
			return # ouside of map
		
		if not pressed:
			_press_piece(coord)
			return # action select
		
		if current_action == null:
			return # no action active
		
		if coord in tile_map_highlight.highlight_coords:
			_add_action(pressed.id, {"action": current_action, "coord": coord})
		
		_cancel_piece()
		
	elif event.is_action_pressed("cancel") and pressed:
		_cancel_piece()

func _press_piece(coord: Vector2i):
	var piece = pieces[coord]
	if piece == null or not piece.infected:
		print("Cannot move uninfected")
		return
	
	pressed = piece
	pressed.open_action_select()
	print("Open action select")

func _cancel_piece():
	if pressed:
		pressed.cancel()
	
	pressed = null
	current_action = null
	tile_map_highlight.highlight_coords = []
	_update_actions()


func _move_active(piece: ParasitePiece, coord: Vector2i):
	var pos = tile_map.map_to_local(coord)
	pieces[coord] = piece
	pieces[piece.coord] = null
	piece.coord = coord
	await piece.move_to(pos)
