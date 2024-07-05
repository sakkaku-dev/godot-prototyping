extends Spawner2D

@export var timer: Timer
@export var angle := Vector2(0, 0)
@export var offset_y := Vector2(0, 0)

var prev_pos: Vector2

func _ready():
	timer.timeout.connect(func():
		offset_dir = Vector2.UP * randf_range(offset_y.x, offset_y.y)
		while prev_pos != null and offset_y.distance_to(prev_pos) < 50:
			offset_dir = Vector2.UP * randf_range(offset_y.x, offset_y.y)
		
		prev_pos = offset_dir
		target_position = Vector2.RIGHT.rotated(deg_to_rad(randf_range(angle.x, angle.y)))
		spawn()
	)
