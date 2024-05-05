class_name Conveyer
extends Node3D

const GROUP = "Conveyer"

@export var dir := Vector3.RIGHT
@export var speed := 1

@onready var move_position = $MovePosition

func _ready():
	add_to_group(GROUP)

func get_velocity(d: float):
	return dir * speed * d
