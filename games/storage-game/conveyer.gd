class_name Conveyer
extends Node3D

const GROUP = "Conveyer"

@export var dir := Vector3.RIGHT
@export var speed := 1
@export var pickup_able := false

@onready var move_position = $MovePosition
@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D

func _ready():
	add_to_group(GROUP)

func get_velocity(d: float):
	return dir * speed * d

func hold():
	collision_shape_3d.disabled = true
	
func hold_release():
	collision_shape_3d.disabled = false
