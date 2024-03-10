class_name SmoothRotation
extends Node

@export var character: CharacterBody2D
@export var rotation_speed := 0.05
@export var rotation_accel := 0.1

var current_rotation := 0.0

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		current_rotation = move_toward(current_rotation, rotation_speed, delta * rotation_accel)
	elif Input.is_action_pressed("move_left"):
		current_rotation = move_toward(current_rotation, -rotation_speed, delta * rotation_accel)
	else:
		current_rotation = move_toward(current_rotation, 0, delta * rotation_accel)

	character.global_rotation += current_rotation
