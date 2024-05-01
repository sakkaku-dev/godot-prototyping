extends CharacterBody3D

@onready var interactable_3d = $Interactable3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var grav_vel: Vector3 # Gravity velocity 

var holding = null

func _ready():
	interactable_3d.interacted.connect(func(actor):
		if holding:
			holding = null
		else:
			holding = actor
	)

func _physics_process(delta):
	if holding:
		global_position = holding.global_position
		global_rotation = holding.global_rotation
		collision_layer = 0
		return

	global_rotation.x = 0
	global_rotation.z = 0
	collision_layer = 3
	velocity = _gravity(delta)
	move_and_slide()

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel
