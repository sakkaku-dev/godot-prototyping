class_name Player3D
extends CharacterBody3D

signal accepted()

@export var run_speed := 8
@export var speed := 5
@export var acceleration := 50
@export var forward := Vector3.FORWARD

@export var animation: AnimationPlayer
@export var phyiscal_bone_simulator: PhysicalBoneSimulator3D
@export var throw_charge: Chargeable

@export var item_nodes: ItemNodes
@export var throw_item: PackedScene
@export var throw_angle := 45.0

@onready var gravity_3d = $Gravity3D
@onready var pivot = $Pivot
@onready var hold_point = $Pivot/HoldPoint
@onready var hand_3d = $Pivot/Hand3D
@onready var run_particles: GPUParticles3D = $Pivot/RunParticles

var walk_vel: Vector3

func _ready() -> void:
	_update_hand_items()
	#phyiscal_bone_simulator.physical_bones_start_simulation()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if hand_3d.interact():
			_update_hand_items()
	elif event.is_action_pressed("action"):
		if hand_3d.action(true):
			return
		
		if not hand_3d.is_holding_item():
			print("Not holding any items to throw")
			return
		
		throw_charge.start()
	elif event.is_action_released("action"):
		if throw_charge.is_charging:
			var force = throw_charge.stop()
			var node = item_nodes.get_node_for_item(hand_3d.item)
			
			var throwing_item = throw_item.instantiate()
			throwing_item.add_child(node.duplicate())
			get_tree().current_scene.add_child(throwing_item)
			throwing_item.global_position = item_nodes.global_position
			
			var quat = pivot.basis.get_euler() as Vector3
			var dir = Vector3.FORWARD.rotated(Vector3.UP, quat.y)
			var throw: Vector3 = dir * force
			var throw_axis = throw.rotated(Vector3.UP, deg_to_rad(90)).normalized()
			
			throw = throw.rotated(throw_axis, deg_to_rad(-throw_angle))
			throwing_item.throw_at(throw)
			
			hand_3d.take_item()
			_update_hand_items()
		else:
			hand_3d.action(false)
	elif event.is_action_pressed("accept"):
		accepted.emit()

func _update_hand_items():
	if hand_3d.is_holding_item():
		item_nodes.show_item(hand_3d.item)
	else:
		item_nodes.hide_all()

func _physics_process(delta: float) -> void:
	var move_2d = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_dir = Vector3(move_2d.x, 0, move_2d.y).normalized()
	if move_dir:
		pivot.basis = Basis.looking_at(move_dir)
	
	animation.play("Walk" if move_2d else "Idle")
	velocity = gravity_3d.apply_gravity(self, delta) + _walk(move_dir, delta)
	move_and_slide()

func _walk_dir(move_dir: Vector3):
	var _forward: Vector3 = global_transform.basis * move_dir
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	return walk_dir

func _walk(move_dir: Vector3, delta: float) -> Vector3:
	var walk_dir = _walk_dir(move_dir)
	var is_running = Input.is_action_pressed("sprint")
	var actual_speed = run_speed if is_running else speed
	run_particles.emitting = is_running and walk_dir
	
	walk_vel = walk_vel.move_toward(walk_dir * actual_speed * move_dir.length(), acceleration * delta)
	return walk_vel
