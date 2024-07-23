extends Camera2D

@export var down_speed := 70
@export var up_speed := 120
@export var deaccel := 400
@export var move_dir := Vector2.ZERO

var velocity = Vector2.ZERO

func _physics_process(delta):
	if move_dir:
		var vel = move_dir * (down_speed if move_dir.y >= 0 else up_speed)
		velocity = velocity.move_toward(vel, deaccel * delta)
		translate(vel * delta)
