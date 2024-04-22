class_name SmoothContainer
extends Control

signal cancel()

@export var child_size := Vector2(0, 40)
@export var vertical := false

var focused_index := 0:
	set(v):
		var current = focused_index
		var next = v
		if v < 0:
			next = get_child_count() - 1
		elif v >= get_child_count():
			next = 0
			
		if next == current:
			return
		
		focused_index = next
		update_children_offsets()

var select_tw: Tween
var tw: Tween

func init():
	_initial_children_positions()
	if focused_index >= get_child_count():
		self.focused_index = 0

func _get_dir() -> Vector2:
	return Vector2.DOWN if vertical else Vector2.RIGHT

func _initial_children_positions():
	var dir = _get_dir()
	var pos = -focused_index * child_size * dir

	for i in get_child_count():
		var c = get_child(i) as Node2D
		if !c or c.top_level or not c.is_visible_in_tree(): continue
		
		c.position = pos + Vector2.LEFT * 100
		
		pos += child_size * dir
	

func update_children_offsets(use_delay := false):
	var dir := _get_dir()
	var pos := -focused_index * child_size * dir

	for i in get_child_count():
		var c = get_child(i) as Control
		if !c or c.top_level or not c.is_visible_in_tree() or c.is_queued_for_deletion(): continue
		
		var diff = i - focused_index
		c.set_new_position(pos)
		c.set_focus(diff == 0)
		
		#var a = 1.0 / max(abs(diff), 1)
		#c.modulate = Color(1, 1, 1, a)
		
		pos += child_size * dir

func get_focused_child():
	for i in get_child_count():
		var c = get_child(i) as Control
		if !c or c.top_level or not c.is_visible_in_tree(): continue
		
		if i == focused_index:
			return c
