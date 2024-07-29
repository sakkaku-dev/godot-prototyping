class_name Hook
extends CharacterBody2D

signal caught()
signal start_reel()

@export var hook_res: HookResource

@export_category("Movement")
@export var descend_speed := 60
@export var ascend_speed := 80

@export_category("Nodes")
@export var line: Line2D
@export var hook_area: Area2D
@export var sprite: Sprite2D
@export var hurtbox: Hurtbox

@onready var gravity = ProjectSettings.get("physics/2d/default_gravity_vector") * ProjectSettings.get("physics/2d/default_gravity")

var has_hooked := false
var capacity := 0
var can_move_up := false
var fish = []
var start_pos := Vector2.ZERO
var move_dir := Vector2.ZERO

func _ready():
	hide()
	
	if not hook_res:
		hook_res = HookResource.new()
	else:
		sprite.texture = hook_res.hook_sprite
		hurtbox.update_max_health(hook_res.durability)

	hook_area.body_entered.connect(_on_hooked)
	hurtbox.hit.connect(func(): ) # TODO: play effect

func _on_hooked(body: Fish):
	if body == null or body.hook or body in fish: return
	body.hook = self
	fish.append(body)
	_start_ascend()

func _start_ascend():
	if not has_hooked:
		move_dir = Vector2.UP
	has_hooked = true

func set_start_position(pos):
	global_position = pos
	start_pos = pos

func _process(_delta):
	line.points = [to_local(global_position - start_pos), Vector2(0, -9)]

func _physics_process(delta: float):
	if not move_dir or not visible: return
	
	var y_speed = move_dir * (descend_speed if move_dir.y > 0 else ascend_speed)
	
	var motion = _get_motion()
	velocity.x = motion.x * hook_res.move_speed
	velocity.y = y_speed.y
	
	# velocity.y = clamp(velocity.y, -hook_res.max_pull_speed, hook_res.max_fall_speed)

	if move_and_slide():
		var collision = get_last_slide_collision()
		var n = collision.get_normal()
		if n.dot(Vector2.UP) > 0.7:
			_start_ascend()

func start_move(pos):
	global_position = pos
	move_dir = Vector2.DOWN
	show()

func remove():
	caught.emit()
	move_dir = Vector2.ZERO
	hide()

#func _unhandled_input(event):
	#if event.is_action_pressed("action") and can_move_up:
		#has_hooked = not has_hooked
		#get_viewport().set_input_as_handled()

func _get_motion():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
