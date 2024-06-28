extends CharacterBody3D

@export var walk_speed := 3.0
@export var run_speed := 5.0
@export var jump_force := 10.0
@export var roll_speed := 25.0
@export var roll_deaccel := 50.0

@export var mouse_sens_horizontal := 0.25
@export var mouse_sens_vertical := 0.3

@onready var base = $base
@onready var camera_mount = $CameraMount
@onready var animation_tree = $AnimationTree

@onready var gravity = 30.0

const MOVE_STATE = "parameters/move/transition_request"
const ROLL_SHOT = "parameters/roll/request"
const ROLL_ACTIVE = "parameters/roll/active"

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

	if is_on_floor() and Input.is_action_just_pressed("roll"):
		animation_tree.set(ROLL_SHOT, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		var dir = velocity.normalized() if velocity else _forward(Vector3.FORWARD)
		velocity = dir * roll_speed
		_face_dir(dir)
	
	var is_rolling = animation_tree.get(ROLL_ACTIVE)
	if not is_rolling:
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
		
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var dir = _forward(Vector3(input_dir.x, 0, input_dir.y))
		
		var is_running = Input.is_action_pressed("run")
		var speed = run_speed if is_running else walk_speed
		if dir:
			_face_dir(dir)
			
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
		if is_on_floor():
			if dir:
				_play_move_anim("run" if is_running else "walk")
			else:
				_play_move_anim("idle")
		else:
			_play_move_anim("fall")
	else:
		velocity.x = move_toward(velocity.x, 0, roll_deaccel * delta)
		velocity.z = move_toward(velocity.z, 0, roll_deaccel * delta)
	
	move_and_slide()

func _forward(dir: Vector3):
	return (transform.basis.rotated(Vector3.UP, PI) * dir).normalized()

func _face_dir(dir: Vector3):
	base.look_at(position - dir)

func _play_move_anim(anim: String):
	animation_tree.set(MOVE_STATE, anim)
