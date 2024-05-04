extends CharacterBody3D

@onready var interactable_3d = $Interactable3D
@onready var gravity_3d = $Gravity3D

var holding := false

func _ready():
	interactable_3d.holding.connect(func(): holding = true)
	interactable_3d.holding_release.connect(func(): holding = false)
	interactable_3d.placing.connect(func(pos):
		global_position = pos
		holding = false
	)

func _physics_process(delta):
	if holding:
		collision_layer = 0
		return

	global_rotation.x = 0
	global_rotation.z = 0
	collision_layer = 3
	velocity = gravity_3d.apply_gravity(self, delta)
	move_and_slide()
