class_name Fireball
extends CharacterBody2D

@export var target_offset := 5
@export var res: FireballResource
@export var burn_area: PackedScene

var target: TypedEnemy

func fire(target: TypedEnemy):
	self.target = target
	
func _physics_process(delta):
	if not target: return
	
	var dir = global_position.direction_to(target.global_position)
	velocity = dir * res.speed
	move_and_slide()

	var dist = global_position.distance_squared_to(target.global_position)
	if dist < 5:
		_to_final_target(dir)
		target.full_hit()
		target = null
		_create_burn_area()
		queue_free()

func _create_burn_area():
	var node = burn_area.instantiate()
	node.global_position = global_position
	node.global_rotation = global_rotation
	node.res = res
	get_tree().current_scene.add_child(node)

func _to_final_target(dir):
	global_position = target.global_position - dir * target_offset
