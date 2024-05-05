class_name Package
extends CharacterBody3D

const GROUP = "package"

@onready var gravity_3d = $Gravity3D
@onready var grid: PackageGridMap = get_tree().get_first_node_in_group(PackageGridMap.GROUP)

var holding := false
var coord: Vector3i

func _ready():
	add_to_group(GROUP)

func _physics_process(delta):
	if holding:
		collision_layer = 0
		return

	global_rotation.x = 0
	global_rotation.z = 0
	collision_layer = 3
	#velocity = gravity_3d.apply_gravity(self, delta)
	#velocity = Vector3.ZERO
	#move_and_slide()

func _process(delta):
	if holding: return

	var new_coord = grid.get_coord(global_position)
	var nodes = grid.get_nodes_at(new_coord)
	
	var conveyers = nodes.filter(func(x): return x.is_in_group(Conveyer.GROUP))
	if not conveyers.is_empty():
		if coord == new_coord:
			var conveyer = conveyers[0] as Conveyer
			translate(conveyer.get_velocity(delta))
	
		if not self in nodes:
			if not grid.move_object(coord, new_coord, self):
				return
		
		coord = new_coord

func hold():
	holding = true
	
func hold_release():
	holding = false

#func place(pos: Vector3):
	#global_position = pos
	#holding = false

