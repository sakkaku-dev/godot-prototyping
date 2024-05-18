extends CharacterBody3D

@onready var ray_cast_3d = $RayCast3D

@export var max_speed := 20
@export var accel := 5

@export var max_rotation := PI/4
@export var rotation_accel := 0.1

func _physics_process(delta):
	var rotate = Input.get_axis("move_right", "move_left")
	if rotate == 0:
		ray_cast_3d.global_rotation.y = move_toward(ray_cast_3d.global_rotation.y, 0, delta)
	else:
		ray_cast_3d.global_rotation.y = clamp(ray_cast_3d.global_rotation.y + rotate * delta, -max_rotation, max_rotation)
	
	var forward = Vector3.FORWARD.rotated(Vector3.UP, ray_cast_3d.global_rotation.y)
	var motion = Input.get_axis("move_down", "move_up")
	velocity = velocity.move_toward(forward * motion * max_speed, accel * delta)
	move_and_slide()
