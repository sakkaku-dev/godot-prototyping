extends CharacterBody3D

@export var speed := 5
@onready var navigation_agent_3d = $NavigationAgent3D

var target: Node3D

func _physics_process(delta):
	if target != null:
		navigation_agent_3d.target_position = target.global_position

	if navigation_agent_3d.is_navigation_finished():
		return

	var next_path_position = navigation_agent_3d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * speed
	_on_velocity_computed(new_velocity)
	
func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
