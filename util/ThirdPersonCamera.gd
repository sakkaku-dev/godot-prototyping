extends Node3D

@export var invert_mouse_y := false
@export_range(0.0, 1.0) var mouse_sensitivity := 0.8
@export var tilt_upper_limit := deg_to_rad(-60.0)
@export var tilt_lower_limit := deg_to_rad(60.0)

@onready var camera: Camera3D = $Camera3D

var _rotation_input: float
var _tilt_input: float
var _mouse_input := false
var _euler_rotation: Vector3

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if invert_mouse_y:
		_tilt_input *= -1

	_euler_rotation.x += _tilt_input * delta
	_euler_rotation.x = clamp(_euler_rotation.x, -PI/2, 0)
	_euler_rotation.y += _rotation_input * delta
	
	transform.basis = Basis.from_euler(_euler_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
