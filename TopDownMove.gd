extends Node

@export var speed := 200

@onready var char: CharacterBody2D = get_parent()

func _physics_process(delta):
	var motion = get_motion()
	char.velocity = motion * speed
	char.move_and_slide()
	
func get_motion():
	return Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
