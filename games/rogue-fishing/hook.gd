class_name Hook
extends CharacterBody2D

signal caught()

@export var speed := 100
@export var accel := 300
@export var max_capacity := 1
@export var terminal_velocity_y := 200

@export_category("Nodes")
@export var line: Line2D
@export var hook_area: Area2D

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var has_hooked := false
var capacity := 0

func _ready():
	hook_area.body_entered.connect(_on_hooked)

func _on_hooked(body: Fish):
	if body == null or _is_max_capacity(): return
	body.hook = self
	capacity += 1
	has_hooked = true

func _is_max_capacity():
	return capacity >= max_capacity

func _process(_delta):
	line.points = [to_local(Vector2.ZERO), Vector2.ZERO];

func _physics_process(delta: float):
	var motion = _get_motion()
	var target_speed = speed if motion else 0
	velocity.x = move_toward(velocity.x, motion * target_speed, accel * delta)

	if has_hooked or _is_max_capacity():
		velocity -= gravity
	else:
		velocity += gravity
	
	if abs(velocity.y) > terminal_velocity_y:
		velocity.y = terminal_velocity_y * sign(velocity.y)

	move_and_slide()

func remove():
	caught.emit()
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		has_hooked = not has_hooked
		get_viewport().set_input_as_handled()

func _get_motion():
	return Input.get_axis("move_left", "move_right")
