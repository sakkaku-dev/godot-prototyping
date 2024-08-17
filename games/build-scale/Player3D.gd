extends CharacterBody3D

@export var speed := 10
@export var jump_force := 12

@export var mouse_sens_horizontal := 0.35
@export var mouse_sens_vertical := 0.3

@onready var base = $base
@onready var camera_mount = $CameraMount

@onready var gravity = 30.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens_horizontal))
		base.rotate_y(deg_to_rad(event.relative.x * mouse_sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(event.relative.y * mouse_sens_vertical))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var dir = (transform.basis.rotated(Vector3.UP, PI) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if dir:
		base.look_at(position - dir)
		
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		#
	#if is_on_floor():
		#if dir:
			#_play_move_anim("run" if is_running else "walk")
		#else:
			#_play_move_anim("idle")
	#else:
		#_play_move_anim("fall")
	
	move_and_slide()

#func _play_move_anim(anim: String):
	#animation_tree.set(MOVE_STATE, anim)
