class_name ControlHover
extends Node

@export var control: Control
@export var dim_color := Color.GRAY

func _ready() -> void:
	control.mouse_entered.connect(func(): control.modulate = Color.WHITE)
	control.mouse_exited.connect(func(): control.modulate = dim_color)
	control.modulate = dim_color
