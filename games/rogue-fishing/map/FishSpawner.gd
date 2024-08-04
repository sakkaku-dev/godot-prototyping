extends Node2D

@export var scene: PackedScene
@export var timer: Timer
@export var angle := Vector2(0, 0)
@export var offset_y := Vector2(0, 0)
@export var region_res: RegionResource

#var prev_pos: Vector2

func _ready():
	timer.timeout.connect(func():
		var node = scene.instantiate()
		var y_offset = randf_range(offset_y.x, offset_y.y)
		var angle = deg_to_rad(randi_range(angle.x, angle.y))
		
		var fish = region_res.fish.pick_random()
		node.fish = fish
		node.global_position = global_position + Vector2(0, y_offset)
		node.global_rotation = angle
		get_tree().current_scene.add_child(node)
		
	)
