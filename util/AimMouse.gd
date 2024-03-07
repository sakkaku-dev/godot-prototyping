extends Node

@export var root: Node2D

func _physics_process(delta):
	var dir = root.global_position.direction_to(root.get_global_mouse_position())
	root.global_rotation = Vector2.RIGHT.angle_to(dir)
