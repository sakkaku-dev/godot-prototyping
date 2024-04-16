class_name TopDownMove2D
extends Node

@export var speed := 200
@onready var character: CharacterBody2D = get_parent()

func process(_delta):
	var motion = get_motion()
	character.velocity = motion * speed
	character.move_and_slide()
	
func get_motion():
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
