class_name Conveyer
extends Node3D

const GROUP = "Conveyer"

@export var dir := Vector3.RIGHT
@export var speed := 1

@onready var move_position = $MovePosition

func _ready():
	add_to_group(GROUP)

func get_velocity(d: float):
	if global_position.x > 5:
		return Vector3.ZERO
	
	return dir * speed * d
