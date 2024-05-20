class_name Bullet
extends CharacterBody2D

@export var speed := 70

var target: TypedCharacter:
	set(v):
		target = v
		target.removed.connect(func(): queue_free())

func _physics_process(delta):
	if not target: return
	
	var dir = global_position.direction_to(target.global_position)
	global_rotation = Vector2.RIGHT.angle_to(dir)
	velocity = dir * speed
	move_and_slide()
	
	var dist = global_position.distance_squared_to(target.global_position)
	if dist < 5:
		target.hit()
		queue_free()
