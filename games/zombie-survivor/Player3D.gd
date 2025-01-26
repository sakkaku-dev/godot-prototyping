extends CharacterBody3D

@export var speed := 10
@export var acceleration := 100

@export var grid: DataGridMap
@export var wall_scene: PackedScene
@export var gun: Gun

@onready var gravity_3d = $Gravity3D
@onready var pivot = $Pivot

@onready var camera: Camera3D = get_viewport().get_camera_3d()

var walk_vel: Vector3
var placing := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if placing:
			var wall = wall_scene.instantiate()
			var player_coord = grid.local_to_map(global_position)
			var aim_dir = Vector3.FORWARD.rotated(Vector3.UP, pivot.global_rotation.y).snapped(Vector3(1, 0 ,1))
			var coord = Vector3i(player_coord.x, 0, player_coord.z) + Vector3i(aim_dir)
			grid.place(coord, wall)
		else:
			gun.fire()
	elif event.is_action_pressed("item_wall"):
		placing = not placing


func _physics_process(delta: float) -> void:
	var move_2d = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_dir = Vector3(move_2d.x, 0, move_2d.y).normalized()
		
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000
	var intersection = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	if not intersection.is_empty(): 
		var dir = pivot.global_position.direction_to(intersection.position)
		dir.y = 0
		pivot.basis = Basis.looking_at(dir)
	
	velocity = gravity_3d.apply_gravity(self, delta) + _walk(move_dir, delta)
	move_and_slide()

func _walk(move_dir: Vector3, delta: float) -> Vector3:
	var _forward: Vector3 = global_transform.basis * move_dir
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel
