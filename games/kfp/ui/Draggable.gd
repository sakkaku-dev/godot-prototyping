class_name Draggable
extends Selectable

signal drag_start()
signal drag_end()

@export var drag_hold_threshold := 0.2
@export var parent: CharacterBody2D

var time := 0.0
var holding := false

var dragging := false
var drag_offset: Vector2

func _gui_input(event: InputEvent):
	if event.is_action_pressed("action"):
		time = 0
		_drag_start()
		#dragging = false
		#holding = true
	elif event.is_action_released("action"):
		dragging = false
		holding = false
		drag_end.emit()

func _drag_start():
	drag_start.emit()
	dragging = true
	
	var center = parent.global_position
	drag_offset = center - parent.get_global_mouse_position()

func get_drag_position():
	var new_center = parent.get_global_mouse_position() + drag_offset
	return new_center

#func _process(delta: float) -> void:
	#if holding and not dragging:
		#time += delta
		#if time >= drag_hold_threshold:
			#_drag_start()
