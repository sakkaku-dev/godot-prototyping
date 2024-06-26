class_name Player3D
extends CharacterBody3D

@export var speed := 5
@export var acceleration := 100
@export var forward := Vector3.FORWARD

@export var conveyer_scene: PackedScene

@export var place_arrow: PlacementArrow
@export var grid: PackageGridMap

@onready var gravity_3d = $Gravity3D
@onready var pivot = $Pivot
@onready var hold_point = $Pivot/HoldPoint
@onready var hand_3d = $Pivot/Hand3D

var walk_vel: Vector3

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if hand_3d.interact():
			return
		
		hold_point.place(place_arrow.global_position)
	elif not hold_point.is_holding():
		if event.is_action_pressed("slot_1"):
			var node = conveyer_scene.instantiate()
			node.pickup_able = true
			grid.add_child(node)
			hold_point.holding = node


func _physics_process(delta: float) -> void:
	var move_2d = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_dir = Vector3(move_2d.x, 0, move_2d.y).normalized()
	if move_dir:
		pivot.basis = Basis.looking_at(move_dir)
	
	velocity = gravity_3d.apply_gravity(self, delta) + _walk(move_dir, delta)
	move_and_slide()


func _walk(move_dir: Vector3, delta: float) -> Vector3:
	var _forward: Vector3 = global_transform.basis * move_dir
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel
