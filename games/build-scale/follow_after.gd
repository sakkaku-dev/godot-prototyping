extends Node3D

@export var follow_target: Node3D
@export var after_y := -100

#func _physics_process(delta: float) -> void:
	#global_position.y = follow_target.global_position.y
