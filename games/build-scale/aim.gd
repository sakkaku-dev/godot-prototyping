extends Node2D

func _process(delta: float) -> void:
	var dir = global_position.direction_to(get_global_mouse_position())
	global_rotation = Vector2.RIGHT.angle_to(dir)
