class_name Coin
extends RigidBody3D

signal picked_up()
signal deadend_reached()
signal left_screen()

@export var scale_speed := 2
@export var max_radius := 1.5
@export var min_radius := 0.2
@export var max_mass := 2
@export var min_mass := 1

@export var max_jump_force := 8
@export var min_jump_force := 5

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var pickup_area: Area3D = $PickupArea
@onready var pickup_collision: CollisionShape3D = $PickupArea/CollisionShape3D
@onready var throw_detector: Area3D = $ThrowDetector
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D

var pos: Vector3
var deadend := false
var can_jump := false
var can_scale := true

var skills: Array[ItemResource.Type] = []

func _ready() -> void:
	global_position = pos
	pickup_area.pickup.connect(func(item):
		_picked_up(item.item)
		item.queue_free()
	)
	
	visible_on_screen_notifier_3d.screen_exited.connect(func(): left_screen.emit())

func _picked_up(item: ItemResource.Type):
	picked_up.emit(item)

func _process(delta: float) -> void:
	if deadend: return
	
	if Input.is_action_pressed("move_up"):
		set_radius(csg_cylinder_3d.radius + scale_speed * delta)
	elif Input.is_action_pressed("move_down"):
		set_radius(csg_cylinder_3d.radius - scale_speed * delta)

func hit_deadend():
	deadend = true
	deadend_reached.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and can_jump and not throw_detector.has_overlapping_areas():
		var force = remap(get_current_radius(), min_radius, max_radius, max_jump_force, min_jump_force)
		apply_central_impulse(Vector3.UP * force)

func get_current_radius():
	return csg_cylinder_3d.radius

func set_radius(radius: float):
	var r = clamp(radius, min_radius, max_radius)
	var shape = collision_shape_3d.shape as CylinderShape3D
	shape.radius = r
	
	var pickup_shape = pickup_collision.shape as SphereShape3D
	pickup_shape.radius = r
	
	csg_cylinder_3d.radius = r
	mass = remap(r, min_radius, max_radius, min_mass, max_mass)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if state.get_contact_count() >= 1:
		can_jump = false
		can_scale = true
		linear_damp = 0
		
		var first_n = Vector2.ZERO
		for x in state.get_contact_count():
			var n = state.get_contact_local_normal(x)
			if not first_n:
				first_n = n
			if n.dot(Vector3.UP) > 0.5:
				can_jump = true
			
			if first_n and n and n.dot(first_n) < 0:
				can_scale = false
		
	else:
		can_jump = false
		linear_damp = 1