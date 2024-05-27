class_name RoomManager
extends Node

signal changed()

const GROUP = "RoomManager"
const DIRS = [Vector2i.LEFT, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN]

@export var map_size := Vector2i(10, 10)
@export var iterations := 30
@export var item_room_chance := 0.1

@onready var spawn: Vector2i = floor(map_size / 2)
@onready var cleared = [spawn]
@onready var coord: Vector2i = spawn:
	set(v):
		if not coord in rooms:
			print("Invalid move to %s" % coord)
			return
		
		coord = v
		changed.emit()

var boss_room: Vector2i
var rooms = {}
var items = []

func _ready():
	add_to_group(GROUP)
	generate()

func generate():
	_create_rooms()
	_mark_item_rooms()
	_mark_boss_room()
	self.coord = spawn

func is_room_cleared():
	return coord in cleared

func _mark_item_rooms():
	for room in rooms:
		var close_items = items.filter(func(p): return Vector2(abs(p - room)).length() <= 2)
		if randf() < item_room_chance and close_items.is_empty():
			items.append(room)

func _mark_boss_room():
	boss_room = _get_random_boss_room()
	rooms[boss_room] = {}

func _get_random_boss_room():
	var room_keys = rooms.keys()
	room_keys.shuffle()
	
	for room in room_keys:
		for dir in _get_unlinked_dirs(room):
			var pos = room + dir
			if get_linked_dirs(pos).size() == 1 and not pos in items:
				return pos
	
	return null

func _get_unlinked_dirs(pos: Vector2i) -> Array:
	return _get_available_dirs(pos).filter(func(d): return not (pos + d) in rooms)

func get_linked_dirs(pos: Vector2i = coord) -> Array:
	return _get_available_dirs(pos).filter(func(d): return (pos + d) in rooms)

func _get_available_dirs(pos: Vector2i):
	return DIRS.duplicate().filter(func(d): return not _is_outside_map(pos + d))

func _create_rooms():
	var start = spawn
	for i in range(iterations):
		rooms[start] = {}
		
		var available_dirs = _get_available_dirs(start)
		if available_dirs.is_empty(): continue
		
		var dir = available_dirs.pick_random()
		start += dir

func _is_outside_map(pos: Vector2i):
	var start = Vector2i.ZERO
	var end = map_size
	return pos.x < start.x or pos.x > end.x or pos.y < start.y or pos.y > end.y
