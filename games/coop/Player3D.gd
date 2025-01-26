class_name Player3D
extends CharacterBody3D

const ARM_BONES = ["UpperArm.L", "LowerArm.L", "UpperArm.R", "LowerArm.R"]

signal accepted()

@export var dash_speed := 20
@export var speed := 5
@export var acceleration := 50
@export var friction := 80
@export var push_force := 20
@export var color := Color.WHITE

@export var player_input: PlayerInput
@export var throw_charge: Chargeable
@export var grid: ShopGridMap

@export var item_nodes: ItemNodes
@export var throw_item: PackedScene
@export var throw_angle := 45.0

@onready var gravity_3d = $Gravity3D
@onready var pivot = $Pivot
@onready var hold_point = $Pivot/HoldPoint
@onready var hand_3d: Hand3D = $Pivot/Hand3D
@onready var run_particles: GPUParticles3D = $Pivot/RunParticles

@onready var cube: MeshInstance3D = $Pivot/base_blob/Armature/Skeleton3D/Cube

# Effects
#@export_category("Effects")
#@export var phyiscal_bone_simulator: PhysicalBoneSimulator3D
#@export var body_bone: PhysicalBone3D
#@onready var freeze_timer: Timer = $FreezeTimer
#@onready var explosion_timer: Timer = $ExplosionTimer

var gravity := 0.9
var walk_vel: Vector3

var is_frozen := false
var knockback := Vector3.ZERO

var is_hold_pressed := false:
	set(v):
		is_hold_pressed = v
		#if is_hold_pressed:
			#animation.prepare_catch()

func _ready() -> void:
	var mat = cube.material_override.duplicate() as ShaderMaterial
	mat.set_shader_parameter("Color", color)
	cube.material_override = mat
	
	#freeze_timer.timeout.connect(func(): is_frozen = false)
	#explosion_timer.timeout.connect(func():
		#phyiscal_bone_simulator.active = false
		#phyiscal_bone_simulator.physical_bones_stop_simulation()
	#)
	
	#hand_3d.body_entered.connect(func(item):
		#if item is ThrowableItem and is_hold_pressed:
			#item.pick_up(hand_3d)
			#_update_hand_items()
	#)
	
	#for c in phyiscal_bone_simulator.get_children():
		#if c is PhysicalBone3D:
			#add_collision_exception_with(c)
	
	_update_hand_items()

	hand_3d.picked_up_at.connect(func(pos: Vector3):
		var p = grid.local_to_map(pos)
		grid.remove(Vector2i(p.x, p.z))
		_update_hand_items()
	)
	
	player_input.just_pressed.connect(func(event: InputEvent):
		if event.is_action_pressed("interact"):
			if hand_3d.is_holding_item() and hand_3d.item is GridItem:
				var face_dir = _get_face_dir() * grid.cell_size
				var player_pos = grid.local_to_map(global_transform.origin + face_dir)
				if await grid.place(Vector2i(player_pos.x, player_pos.z), hand_3d.item):
					hand_3d.take_item()
					_update_hand_items()
				else:
					hand_3d.interact()
			elif hand_3d.interact():
				_update_hand_items()
		elif event.is_action_pressed("action"):
			if hand_3d.action(true):
				#animation.start_work()
				return
			
			if not hand_3d.is_holding_item():
				is_hold_pressed = true
				return
				
			if not hand_3d.item is PotionItem:
				print("Can only throw potion items")
				return 
			
			throw_charge.start()
		elif event.is_action_pressed("accept"):
			accepted.emit()
		elif event.is_action_pressed("dash"):
			var b = pivot.basis as Basis
			knockback = Vector3.FORWARD * dash_speed * b.get_rotation_quaternion().inverse()
			run_particles.emitting = true
	)
	
	player_input.just_released.connect(func(event: InputEvent):
		if event.is_action_released("action"):
			if throw_charge.is_charging:
				var force = throw_charge.stop()
				var node = item_nodes.get_node_for_item(hand_3d.item)
				
				var throwing_item = throw_item.instantiate()
				throwing_item.add_child(node.duplicate())
				throwing_item.item = hand_3d.item
				get_tree().current_scene.add_child(throwing_item)
				throwing_item.global_position = item_nodes.global_position
				
				var dir = _get_face_dir()
				var throw: Vector3 = dir * force
				var throw_axis = throw.rotated(Vector3.UP, deg_to_rad(90)).normalized()
				
				throw = throw.rotated(throw_axis, deg_to_rad(-throw_angle))
				throwing_item.throw_at(throw)
				
				hand_3d.take_item()
				_update_hand_items()
			else:
				hand_3d.action(false)
			
			is_hold_pressed = false
	)

func _get_face_dir():
	var quat = pivot.basis.get_euler() as Vector3
	return Vector3.FORWARD.rotated(Vector3.UP, quat.y)

func _update_hand_items():
	if hand_3d.is_holding_item():
		item_nodes.show_item(hand_3d.item)
	else:
		item_nodes.hide_all()

func _physics_process(delta: float) -> void:
	#if is_frozen or phyiscal_bone_simulator.active:
		#animation.active = false
		#return
	
	#animation.active = true
	if is_hold_pressed: return
	
	var move_dir := Vector3.ZERO
	if knockback:
		velocity = knockback
		knockback = knockback.move_toward(Vector3.ZERO, delta * friction)
	else:
		var move_2d = player_input.get_vector("move_right", "move_left", "move_down", "move_up")
		move_dir = Vector3(move_2d.x, 0, move_2d.y).normalized()
		if move_dir:
			pivot.basis = Basis.looking_at(move_dir)
		
		#animation.play("Walk" if move_2d else "Idle")
		var walk_dir = _walk(move_dir, delta)
		velocity.x = walk_dir.x
		velocity.z = walk_dir.z
	
	if not is_on_floor():
		velocity.y -= gravity
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var bone = c.get_collider() as PhysicalBone3D
		if bone:
			bone.apply_central_impulse(-c.get_normal() * push_force)
			
	#animation.update(self)
			

func _walk_dir(move_dir: Vector3):
	var _forward: Vector3 = global_transform.basis * move_dir
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	return walk_dir

func _walk(move_dir: Vector3, delta: float) -> Vector3:
	var walk_dir = _walk_dir(move_dir)
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

### Effects ###

func freeze():
	is_frozen = true
	#freeze_timer.start()

func explode(from: Vector3):
	var dir = from.direction_to(global_position)
	#phyiscal_bone_simulator.physical_bones_start_simulation()
	#body_bone.apply_central_impulse(dir * 200)
	#explosion_timer.start()

func levitate():
	pass
