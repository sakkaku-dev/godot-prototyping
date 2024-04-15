class_name Transition
extends Node

@export var node: Control
@export var dir := Vector2.RIGHT
@export var extra_offset := Vector2.ZERO

@onready var original_position := node.position

var tw: Tween

func _ready():
	node.position = _hide_position()

func _hide_position():
	return original_position + dir * node.size + extra_offset

func _new_tween():
	if tw and tw.is_running():
		tw.kill()
	
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func open():
	_new_tween()
	tw.tween_property(node, "position", original_position, 0.5)
	
func close():
	_new_tween()
	tw.tween_property(node, "position", _hide_position(), 0.5)
