class_name NavigationMove2D
extends NavigationAgent2D

signal reached()

@export var speed := 100
@export var enemy: CharacterBody2D

var has_reached := false

func _ready():
	velocity_computed.connect(_on_velocity_computed)
	
func set_target(movement_target: Vector2):
	has_reached = false
	set_target_position(movement_target)
	
func _on_velocity_computed(safe_velocity):
	enemy.velocity = safe_velocity
	enemy.move_and_slide()
	
func process(delta):
	if is_navigation_finished():
		if not has_reached:
			has_reached = true
			reached.emit()
		return
	
	var next_path_position = get_next_path_position()
	var new_velocity = enemy.global_position.direction_to(next_path_position) * speed
	if avoidance_enabled:
		set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
