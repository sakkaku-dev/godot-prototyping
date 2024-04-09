extends Node

signal reached()

@export var body: CharacterBody2D
@export var speed := 50
@export var target_distance := 5
@export var stop := false

var current_target
var current_dir := Vector2.ZERO

func _physics_process(delta):
	if stop:
		return
	
	if current_target == null:
		return
	
	current_dir = body.global_position.direction_to(current_target)
	body.velocity = current_dir * speed
	body.move_and_slide()
	
	if body.global_position.distance_to(current_target) < target_distance:
		current_target = null
		reached.emit()
