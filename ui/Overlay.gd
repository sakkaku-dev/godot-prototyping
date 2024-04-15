class_name Overlay
extends ColorRect

signal close()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		close.emit()
