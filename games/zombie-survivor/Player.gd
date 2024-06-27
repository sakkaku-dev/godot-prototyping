extends CharacterBody2D

@export var tile_map: TileMap

@onready var top_down_move_2d = $TopDownMove2D
@onready var ray_cast_2d = $RayCast2D
@onready var placeholder = $Placeholder

var placing = false

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if not placing:
			if ray_cast_2d.is_colliding():
				ray_cast_2d.get_collider().damage(1)
		else:
			tile_map.set_cell(0, _get_place_coord(), 2, Vector2(0, 0), 1)
	elif event.is_action_pressed("item_wall"):
		placing = true

func _physics_process(delta):
	var aim = _get_aim()
	ray_cast_2d.rotation = Vector2.RIGHT.angle_to(aim)
	top_down_move_2d.process(delta)

	placeholder.visible = placing
	if placing:
		placeholder.global_position = tile_map.map_to_local(_get_place_coord())

func _get_place_coord():
	var coord = tile_map.local_to_map(global_position)
	var aim = Vector2i(_get_aim().snapped(Vector2(1, 1)))
	print(aim)
	return coord + aim

func _get_aim():
	return global_position.direction_to(get_global_mouse_position())
