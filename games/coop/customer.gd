class_name ShopCustomer
extends CharacterBody3D

signal has_left()

@export var speed := 4

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var pivot: Node3D = $Pivot

var return_pos: Vector3
var ordering_item: PotionItem.Type = -1
var leaving := false

func move_to(pos: Vector3):
	navigation_agent_3d.target_position = pos

func _physics_process(delta):
	if navigation_agent_3d.is_navigation_finished():
		if leaving:
			has_left.emit()
			queue_free()
		return

	var next_path_position = navigation_agent_3d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * speed
	
	if new_velocity:
		pivot.basis = Basis.looking_at(new_velocity)
	_on_velocity_computed(new_velocity)
	
func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

func set_order(item: PotionItem.Type):
	ordering_item = item

func leave():
	move_to(return_pos)
	leaving = true
