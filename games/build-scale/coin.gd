class_name Coin
extends RigidBody3D

signal picked_up()
signal deadend_reached()

@export var scale_speed := 2
@export var max_radius := 1.5
@export var min_radius := 0.2
@export var max_mass := 2
@export var min_mass := 0.5

@export var max_jump_force := 10
@export var min_jump_force := 5

@onready var csg_cylinder_3d: CSGCylinder3D = $CSGCylinder3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var pickup_area: Area3D = $PickupArea
@onready var pickup_collision: CollisionShape3D = $PickupArea/CollisionShape3D
@onready var throw_detector: Area3D = $ThrowDetector

var pos: Vector3
var deadend := false
var can_jump := false

var skills: Array[ItemResource.Type] = []

func _ready() -> void:
	global_position = pos
	pickup_area.pickup.connect(func(item):
		_picked_up(item.item.type)
		item.queue_free()
	)

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
	#mass = remap(r, min_radius, max_radius, min_mass, max_mass)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if state.get_contact_count() >= 1:
		can_jump = false
		for x in state.get_contact_count():
			if state.get_contact_local_normal(x).dot(Vector3.UP) > 0.5:
				can_jump = true
	else:
		can_jump = false
