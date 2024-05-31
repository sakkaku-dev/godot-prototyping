# https://www.youtube.com/watch?v=LqLchhxMldM
extends Node3D

## Engine power
@export var acceleration := 50

## Turn amount, in degrees
@export var steering := 21.

## How quickly the car turns
@export var turn_speed := 5

## Below this speed the car doesn't turn
@export var turn_stop_limit = 0.75

@export var body_tilt := 35

@onready var mesh = $Mesh
@onready var ground_cast = $Mesh/GroundCast
@onready var ball = $Ball
@onready var sphere_offset: Vector3 = mesh.transform.origin

@onready var wheel_front_left = $Mesh/delivery/wheel_frontLeft
@onready var wheel_front_right = $Mesh/delivery/wheel_frontRight
@onready var body = $Mesh/delivery/body

@onready var smoke = $Mesh/Smoke
@onready var smoke_2 = $Mesh/Smoke2

var speed_input = 0
var rotate_input = 0

func _ready():
	ground_cast.add_exception(ball)

func _physics_process(delta):
	mesh.transform.origin = ball.transform.origin + sphere_offset
	ball.apply_central_force(-mesh.global_transform.basis.z * speed_input)

func _process(delta):
	if not ground_cast.is_colliding():
		return
	
	speed_input = 0
	speed_input += Input.get_action_strength("move_up")
	speed_input -= Input.get_action_strength("move_down")
	speed_input *= acceleration
	
	rotate_input = 0
	rotate_input += Input.get_action_strength("move_left")
	rotate_input -= Input.get_action_strength("move_right")
	rotate_input *= deg_to_rad(steering)
	
	wheel_front_right.rotation.y = rotate_input
	wheel_front_left.rotation.y = rotate_input
	
	var d = ball.linear_velocity.normalized().dot(-mesh.transform.basis.z)
	smoke.emitting = ball.linear_velocity.length() > 5.5 and d < 0.9
	smoke_2.emitting = smoke.emitting
	
	if ball.linear_velocity.length() > turn_stop_limit:
		var new_basis = mesh.global_transform.basis.rotated(mesh.global_transform.basis.y, rotate_input)
		mesh.global_transform.basis = mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		mesh.global_transform = mesh.global_transform.orthonormalized()
		
		# tilt body for effect
		var t = -rotate_input * ball.linear_velocity.length() / body_tilt
		body.rotation.z = lerp(body.rotation.z, t, 10 * delta)
		
	var n = ground_cast.get_collision_normal() as Vector3
	var xform = align_with_y(mesh.global_transform, n.normalized())
	mesh.global_transform = mesh.global_transform.interpolate_with(xform, 10 * delta)

func align_with_y(xform: Transform3D, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
