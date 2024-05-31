extends CharacterBody3D

@onready var camera = $Pivot/Camera

@export var sprint_timer: Timer
@export var speed = 2
@export var sprint_speed = 4
@export var mouse_sensitivity = 0.004  # radians/pixel
@export var jump_force := 5

var gravity = -20
var wall_gravity := -10
var sprinting := false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
	if event.is_action_pressed("move_up"):
		if sprint_timer.is_stopped():
			sprint_timer.start()
		else:
			sprinting = true
	elif event.is_action_released("move_up") and sprinting:
		sprinting = false
		

func get_input():
	var input_dir = Vector3()
	
	# desired move in camera direction
	if Input.is_action_pressed("move_up"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_down"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
		
	input_dir = input_dir.normalized()
	return input_dir

func _physics_process(delta):
	var g = gravity if not is_on_wall() else wall_gravity
	velocity.y += g * delta
	
	var desired_velocity = get_input() * (speed if not sprinting else sprint_speed)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	move_and_slide()
	
	
