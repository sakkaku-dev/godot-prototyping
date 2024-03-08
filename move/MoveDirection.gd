class_name MoveDirection
extends Node

@export var node: CharacterBody2D
@export var dir := Vector2.RIGHT
@export var speed := 300

func _ready():
	dir = Vector2.RIGHT.rotated(node.global_rotation)
	node.global_rotation = Vector2.RIGHT.angle_to(dir)

func _physics_process(delta):
	node.velocity = dir * speed
	node.move_and_slide()
