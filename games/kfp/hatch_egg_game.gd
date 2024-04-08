extends Node2D

signal hatched()

@export var marker: Node2D # setting Node2D position is much smoother than a ColorRect
@export var temp_bar: ColorRect

@export var range_root: Node2D
@export var range_bar: ColorRect

@export var time_string: TimeString

@export var max_temp := 100.0
@export var temp_increase := 50.0
@export var max_time_multiplier := 50.0

var range_tw: Tween

var time_multiplier := 1.0
var current_time_left := 1000.0:
	set(v):
		current_time_left = max(v, 0.0)
		time_string.set_time(current_time_left)
		
		if current_time_left <= 0:
			hatched.emit()

var current_temp := 0.0:
	set(v):
		current_temp = clamp(v, 0.0, max_temp)
		var p = current_temp / max_temp
		var full_height = temp_bar.size.y - 3 #marker.size.y
		var height = full_height * p
		
		marker.position.y = full_height - height

func _ready():
	_move_range_random()

func _physics_process(delta):
	if Input.is_action_pressed("action"):
		self.current_temp += temp_increase * delta
	else:
		self.current_temp -= temp_increase * delta
	
	time_multiplier = 1.0 + max_time_multiplier * _marker_distance_to_center_range()
	self.current_time_left -= delta * time_multiplier

func _move_range_random():
	var max_y = temp_bar.size.y - range_bar.size.y
	
	#var delta_y = randf_range(min_range_move, max_range_move)
	#var negative_p = 0.5
	#if range_root.position.y <= min_range_move:
		#negative_p = 0.0
	#elif range_root.position.y >= max_y - min_range_move:
		#negative_p = 1.0
	#
	#print(max_y)
	#var random_y = clamp(range_root.position.y + delta_y * -1 if randf() <= negative_p else 1, 0.0, max_y)
	var random_y = randf_range(0.0, max_y)
	
	if range_tw and range_tw.is_running():
		range_tw.kill()
	
	var time = randf_range(0.5, 1.5)
	range_tw = create_tween()
	range_tw.tween_property(range_root, "position:y", random_y, time)
	range_tw.finished.connect(func(): _move_range_random())

func _marker_distance_to_center_range():
	var center = range_root.position.y + range_bar.size.y / 2
	var pos = marker.position.y
	var max_dist = range_bar.size.y / 2
	
	var p = 1.0 - clamp(abs(center - pos) / max_dist, 0.0, 1.0)
	return p
