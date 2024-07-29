extends Node2D

@export var player: Node2D

func _process(delta):
	global_position.y = player.global_position.y
