class_name AutoMove
extends Node

@export var character: CharacterBody2D
@export var dir := Vector2.RIGHT
@export var speed := 100
@export var accel := 400
@export var enabled := true

func _physics_process(delta):
	if enabled:
		character.velocity = character.velocity.move_toward(dir * speed, delta * accel)
		character.move_and_slide()
