class_name ShadowAlchemist
extends CharacterBody3D

@export var max_speed = 5
@export var mouse_sensitivity = 0.01
@export var hold_item_scene: PackedScene

@onready var hand = $Pivot/Hand
@onready var camera_3d = $Pivot/Camera3D
@onready var pivot = $Pivot
@onready var hold_position = $Pivot/HoldPosition

var gravity = -30
var items := {}

var holding_item: Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func item_hold(item: ShadowAlchemyItem.Type):
	if holding_item:
		holding_item.queue_free()
		holding_item = null
	
	var node = hold_item_scene.instantiate()
	hold_position.add_child(node)
	holding_item = node

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
	
	if event.is_action_pressed("interact"):
		var areas = hand.get_overlapping_areas()
		if not areas.is_empty():
			var item = areas[0].type
			areas[0].pick_up()
			
			if not item in items:
				items[item] = 0
			items[item] += 1
	elif event.is_action_pressed("action") and holding_item:
		holding_item.reparent(get_tree().current_scene)
		holding_item.throw(-camera_3d.global_transform.basis.z * 13)
		holding_item = null
	elif event.is_action_pressed("item_1"):
		item_hold(ShadowAlchemyItem.Type.NITROGEN)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_motion() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	move_and_slide()

func get_motion():
	var input_dir = Vector3.ZERO
	
	if Input.is_action_pressed("move_up"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_down"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	
	return input_dir.normalized()
