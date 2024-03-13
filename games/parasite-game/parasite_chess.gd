extends Node2D

signal turn_changed(pieces, current)

@export var pieces_scene: Array[PackedScene] = []
@export var piece_count := 3

@export var move_color := Color.BLUE
@export var attack_color := Color.RED
@export var jump_color := Color.GREEN
@export var standby_color := Color.GRAY
@export var action_used_color := Color.DARK_GRAY

@onready var tile_map = $TileMap
@onready var tile_map_highlight = $TileMapHighlight
@onready var attack_highlight = $AttackHighlight
@onready var cursor = $Cursor
@onready var panel_container = $CanvasLayer/PanelContainer

var initial_infect := false
var is_executing := false
var pressed = null
#var pieces := {}

var actions := {}
var current_action

var current_turn := 0
var players := []

func _ready():
	var exclude := []
	
	#for c in tile_map.get_used_cells(tile_map.layer):
		#pieces[c] = null
	
	for i in piece_count:
		var scene = pieces_scene.pick_random()
		if i < pieces_scene.size():
			scene = pieces_scene[i]
		
		var piece = scene.instantiate()
		
		tile_map.add_child(piece)
		
		if i == 0:
			piece.set_colors(move_color, attack_color, jump_color, standby_color)
		
		var tile = tile_map.random_tile(exclude)
		piece.global_position = tile_map.map_to_local(tile)
		piece.coord = tile
		piece.id = i
		piece.tilemap = tile_map
		piece.do_action.connect(func(a): _start_action_select(a, piece))
		piece.died.connect(func():
			players.erase(piece)
			#turn_changed.emit(players, current_turn)
		)
		#pieces[tile] = piece
		players.append(piece)
		
		exclude.append(tile)
		exclude.append_array(tile_map.get_neighbors(tile))
	
	turn_changed.emit(players, current_turn)
	turn_changed.connect(func(pieces, turn): panel_container.update(pieces, turn))

func _update_actions():
	pass
	#for p in players:
		#p.modulate = action_used_color if p.id in actions else Color.WHITE
		
func _execute_actions():
	is_executing = true
	
	var executed = []
	for p in players:
		if p.id in actions:
			var data = actions[p.id]
			
			if data.action == ParasitePiece.Action.MOVE:
				#_move_active(p, data.coord)
				await p.move_to_direction(data.coord)
			elif data.action == ParasitePiece.Action.ATTACK:
				var new_coord = await p.attack(tile_map.map_to_local(data.coord))
				#if new_coord != null:
					#_move_active(p, new_coord)
					#print("New attack position %s" % new_coord)
			elif data.action == ParasitePiece.Action.JUMP:
				await p.jump_to(tile_map.map_to_local(data.coord))
			_clear_action(p.id)
			
			#players.erase(p)
			#players.push_back(p)

#func _move_active(piece: ParasitePiece, coord: Vector2i):
	#pieces[piece.coord] = null
	#pieces[coord] = piece
	#piece.coord = coord

func _clear_action(id):
	actions.erase(id)
	if actions.size() == 0:
		_next_turn()
	
	_update_actions()

func _next_turn():
	print("Turn %s finished." % current_turn)
	current_turn += 1
	if current_turn >= players.size():
		current_turn = 0
	print("Next Turn %s." % current_turn)
	
	turn_changed.emit(players, current_turn)
	
	var piece = players[current_turn]
	if piece.infected:
		_player_turn()
	else:
		_process_ai(piece)

func _process_ai(enemy: ParasitePiece):
	print("Processing AI move: %s" % [enemy.id])
	var players = players.filter(func(x): return x != enemy and x.infected)
	var others = players.filter(func(x): return x != enemy and not x.infected)
	await enemy.process(players, others)
	_next_turn()

func _player_turn():
	print("Players turn")
	is_executing = false

func _add_action(id, data):
	actions[id] = data
	if _get_remaining_infected().is_empty():
		print("All infected moved. Executing actions")
		_execute_actions()

func _get_remaining_infected():
	var infected = []
	for p in players:
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
	_clear_highlights()
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.moveable_tiles()
func _show_attacks(p: ParasitePiece, c: Color):
	_clear_highlights()
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.attackable_tiles()
func _show_jump(p: ParasitePiece, c: Color):
	_clear_highlights()
	tile_map_highlight.highlight_color = c
	tile_map_highlight.highlight_coords = p.jumpable_tiles()
func _highlight_moves(p: ParasitePiece):
	tile_map_highlight.highlight_color = move_color
	tile_map_highlight.highlight_coords = p.moveable_tiles()
	attack_highlight.highlight_color = attack_color
	attack_highlight.highlight_coords = p.attackable_tiles()
func _clear_highlights():
	tile_map_highlight.highlight_coords = []
	attack_highlight.highlight_coords = []

func _find_piece_at(coord: Vector2i):
	for p in players:
		if p.coord == coord:
			return p
	return null

func _unhandled_input(event):
	var coord = tile_map.local_to_map(get_global_mouse_position())
	
	if not tile_map.has_value(coord):
		return # outside of map
	
	if event is InputEventMouseMotion:
		cursor.global_position = tile_map.map_to_local(coord) - cursor.size/2
		var p = _find_piece_at(coord)
		if current_action == null:
			if p != null:
				_highlight_moves(p)
			else:
				_clear_highlights()
	
	if event.is_action_pressed("action") and not initial_infect:
		var p = _find_piece_at(coord)
		if p:
			initial_infect = true
			p.infected = true
			current_turn = p.id
			turn_changed.emit(players, current_turn)
			return
	
	if is_executing: return
	
	if event.is_action_pressed("action"):
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
	var piece = _find_piece_at(coord)
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
