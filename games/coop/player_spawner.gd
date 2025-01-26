class_name PlayerSpawner
extends Marker3D

signal all_players_ready()

@export var player: PackedScene
@export var grid: ShopGridMap
@export var splitscreen: SplitscreenContainer

@export var colors: Array[Color] = []

var ready_players := {}
var started := false
var players = []

func _unhandled_input(event: InputEvent) -> void:
	if not started:
		var existing = _find_input_for(event)
		if not existing:
			_create_player(event)

func _create_player(event: InputEvent):
	var input = _create_input(event) as PlayerInput
	var player_node = player.instantiate() as Player3D
	
	add_child(input)
	
	var player_id = input.get_id()
	player_node.player_input = input
	player_node.grid = grid
	player_node.color = colors[get_child_count()] if get_child_count() < colors.size() else Color.WHITE
	player_node.position = position
	splitscreen.add_player(player_node, players.size())
	players.append(player_node)
	
	ready_players[player_id] = false
	
	player_node.accepted.connect(func():
		if started: return
		
		ready_players[player_id] = not ready_players[player_id]
		#ready_container.set_ready(player_id, ready_players[player_id])
		
		if is_everyone_ready():
			all_players_ready.emit()
			started = true
			reset_ready_state()
	)

func _create_input(event: InputEvent):
	var input = PlayerInput.new()
	input.set_for_event(event)
	return input

func _find_input_for(event: InputEvent):
	var joypad = PlayerInput.is_joypad_event(event)
	var device = event.device
	
	for c in get_children():
		if not c is PlayerInput: continue
		
		var input = c as PlayerInput
		if input.device_id == device and input.joypad == joypad:
			return input
	
	return null
	
func get_player_count():
	return get_children().size()

func is_everyone_ready():
	return ready_players.values().filter(func(x): return not x).is_empty()

func reset_ready_state():
	for x in ready_players:
		ready_players[x] = false

func shop_closed():
	#ready_container.reset()
	started = false
