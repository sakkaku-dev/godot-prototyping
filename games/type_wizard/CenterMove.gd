extends Node

@export var speed := 10

func move(body: CharacterBody2D, delta):
	var dir = body.global_position.direction_to(Vector2.ZERO)
	body.velocity = dir * speed
	body.move_and_slide()
