extends Node2D

@export var scene: PackedScene

func _ready():
	pass
	
func _spawn():
	var node = scene.instantiate()
	add_child(node)
