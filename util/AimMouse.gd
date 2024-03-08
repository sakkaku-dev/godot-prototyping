class_name AimMouse
extends Node

@export var root: Node2D

func get_root():
	return root if root else get_parent()

func _physics_process(delta):
	var node = get_root()
	var dir = node.global_position.direction_to(node.get_global_mouse_position())
	node.global_rotation = Vector2.RIGHT.angle_to(dir)
