class_name PositionEffect
extends Effect

@export var node: Control
@export var dir := Vector2.RIGHT
@export var extra_offset := Vector2.ZERO

@onready var original_position := node.position

func _ready():
	node.position = _hide_position()

func _hide_position():
	return original_position + dir * node.size + extra_offset
	
func open():
	_new_tween()
	tw.tween_property(node, "position", original_position, 0.5)
	
func close():
	_new_tween()
	tw.tween_property(node, "position", _hide_position(), 0.5)
