extends Node2D

@export var obstacles: Array[PackedScene] = []

func spawn(pos: Vector2):
	var obstacle = obstacles.pick_random()
	var node = obstacle.instantiate()
	node.global_position = pos
	get_tree().current_scene.add_child(node)
