class_name Hook
extends CharacterBody2D

signal caught()

@export var hook_res: HookResource

@export_category("Nodes")
@export var line: Line2D
@export var hook_area: Area2D
@export var sprite: Sprite2D
@export var hurtbox: Hurtbox

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var has_hooked := false
var capacity := 0
var can_move_up := false

func _ready():
	if not hook_res:
		hook_res = HookResource.new()
	else:
		sprite.texture = hook_res.hook_sprite
		hurtbox.update_max_health(hook_res.durability)

	hook_area.body_entered.connect(_on_hooked)
	hurtbox.hit.connect(func(): ) # TODO: play effect

func _on_hooked(body: Fish):
	if body == null or _is_max_capacity(): return
	body.hook = self
	capacity += 1
	has_hooked = true

func _is_max_capacity():
	return capacity >= hook_res.max_capacity

func _process(_delta):
	line.points = [-global_position, Vector2.ZERO];

func _physics_process(delta: float):
	var motion = _get_motion()
	var target_speed = hook_res.move_speed if motion else 0
	velocity.x = move_toward(velocity.x, motion * target_speed, hook_res.accel * delta)

	if has_hooked or _is_max_capacity():
		velocity -= gravity
	else:
		velocity += gravity
	
	velocity.y = clamp(velocity.y, -hook_res.max_pull_speed, hook_res.max_fall_speed)

	move_and_slide()

func remove():
	caught.emit()
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("action") and can_move_up:
		has_hooked = not has_hooked
		get_viewport().set_input_as_handled()

func _get_motion():
	return Input.get_axis("move_left", "move_right")
