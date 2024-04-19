extends Node

@export var node: Node2D
@onready var original_rotation := node.global_rotation

func _process(delta):
	var parent = node.get_parent()
	node.global_rotation = -parent.global_rotation
