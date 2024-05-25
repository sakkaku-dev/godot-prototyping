class_name CircleIndicator
extends Node

@export var color_rect: ColorRect
@export var collision_shape: CollisionShape2D
@export var hide_on_start := false

func _ready():
	update()
	
func update():
	var shape = collision_shape.shape
	if not shape: return
	
	if shape is CircleShape2D:
		color_rect.size = Vector2(shape.radius * 2, shape.radius * 2)
	elif shape is CapsuleShape2D:
		color_rect.size = Vector2(shape.height, shape.radius * 2)
	else:
		print("Unknown shape for circle indicator")
	
	color_rect.global_position = collision_shape.global_position - color_rect.size / 2
	
	if hide_on_start:
		color_rect.hide()
		
func show_indicator():
	color_rect.show()
