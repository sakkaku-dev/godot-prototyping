class_name Cursor
extends Node2D

@export var tile_map: TileMap

@export var is_focused := false:
	set(v):
		is_focused = v
		visible = v

var coord := Vector2i.ZERO:
	set(v):
		coord = v
		
		var pos = tile_map.map_to_local(coord)
		global_position = pos
		
		print("%s - %s" % [coord, pos])

func _ready():
	self.coord = Vector2.ZERO
	hide()

func _unhandled_input(event):
	if not is_focused: return
	
	if event is InputEventMouseMotion:
		self.coord = tile_map.local_to_map(get_global_mouse_position())
	
	if event.is_action_pressed("ui_up"):
		self.coord += Vector2i.UP
	elif event.is_action_pressed("ui_down"):
		self.coord += Vector2i.DOWN
	elif event.is_action_pressed("ui_left"):
		self.coord += Vector2i.LEFT
	elif event.is_action_pressed("ui_right"):
		self.coord += Vector2i.RIGHT

func get_map_position():
	return tile_map.local_to_map(global_position)
