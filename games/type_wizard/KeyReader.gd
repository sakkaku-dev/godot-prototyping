class_name KeyReader
extends Node

signal pressed_key(key, shift)
signal pressed_cancel(shift)

func _unhandled_input(event: InputEvent):
	if not event is InputEventKey: return
	if not event.pressed: return
	
	if event.is_action_pressed("ui_cancel"):
		pressed_cancel.emit(event.shift_pressed)
		return
	
	var key = _get_key_of_event(event)
	if not key: return
	
	pressed_key.emit(key.to_lower(), event.shift_pressed)

func _get_key_of_event(ev: InputEventKey):
	var key = ev.duplicate() as InputEventKey
	
	# we don't care about modifiers
	key.shift_pressed = false
	key.ctrl_pressed = false
	key.alt_pressed = false
	key.meta_pressed = false
	
	var text = key.as_text()
	if text.length() != 1:
		return null
	return text
