class_name Thrown
extends Node

@export var node: CharacterBody2D
@export var deaccel := 1200

func throw(dir: Vector2):
	node.velocity = dir

func _physics_process(delta):
	node.velocity = node.velocity.move_toward(Vector2.ZERO, deaccel * delta)
	node.move_and_slide()
