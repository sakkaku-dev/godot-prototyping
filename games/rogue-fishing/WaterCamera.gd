extends Camera2D

@export var speed := 50
@export var deaccel := 400
@export var move_dir := Vector2.ZERO

var velocity = Vector2.ZERO

func _physics_process(delta):
	if move_dir:
		velocity = velocity.move_toward(move_dir * speed, deaccel * delta)
		translate(move_dir * speed * delta)
