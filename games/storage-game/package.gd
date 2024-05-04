class_name Package
extends CharacterBody3D

const GROUP = "package"

@onready var gravity_3d = $Gravity3D

var holding := false

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
	#move_and_slide()

func hold():
	holding = true
	
func hold_release():
	holding = false

func place(pos: Vector3):
	global_position = pos
	holding = false
