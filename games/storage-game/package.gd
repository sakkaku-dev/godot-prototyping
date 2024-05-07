class_name Package
extends CharacterBody3D

const GROUP = "package"

@export var res: PackageResource
@export var collision_detection_distance := 0.5

@onready var ray_cast_3d = $RayCast3D
@onready var gravity_3d = $Gravity3D
@onready var grid: PackageGridMap = get_tree().get_first_node_in_group(PackageGridMap.GROUP)

var is_moving := false
var holding := false
var coord: Vector3i

func _ready():
	add_to_group(GROUP)

func get_max_weight():
	return res.weight * 2

func get_weight():
	return res.weight

func break_package():
	queue_free()

func _process(delta: float):
	if holding: return

	var new_coord = grid.get_coord(global_position)
	var nodes = grid.get_nodes_at(new_coord)
	
	if self in nodes:
		var conveyers = nodes.filter(func(x): return x.is_in_group(Conveyer.GROUP))
		is_moving = not conveyers.is_empty()
		
		if is_moving:
			_move_by_conveyer(conveyers[0], delta)
		else:
			_adjust_position(new_coord)
			
		coord = new_coord
	else:
		grid.move_object(coord, new_coord, self)

func _adjust_position(coord: Vector3i):
	global_position = grid.get_position_for(self, coord)

func _move_by_conveyer(conveyer: Conveyer, delta: float):
	var vel = conveyer.get_velocity(delta)
	ray_cast_3d.target_position = vel.normalized() * collision_detection_distance
	
	var collider = ray_cast_3d.get_collider()
	if collider == null or not collider.is_moving:
		translate(vel)

func hold():
	holding = true
	
func hold_release():
	holding = false
