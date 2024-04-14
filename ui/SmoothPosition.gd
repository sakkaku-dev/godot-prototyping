class_name SmoothPosition
extends Control

signal selected()
signal focused(is_focused)

@export var center_position := false

var tw: Tween
var focus_tw: Tween
var is_focused = null

func set_focus(f: bool):
	is_focused = f
	focused.emit(f)

func set_new_position(pos: Vector2, delay := 0.0):
	if tw and tw.is_running():
		tw.kill()
		
	var new_pos = pos
	if center_position:
		new_pos -= size / 2.0
	
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "position", new_pos, 0.5).set_delay(delay)
	return tw
