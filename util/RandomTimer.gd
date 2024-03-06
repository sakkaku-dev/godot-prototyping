class_name RandomTimer
extends Timer

@export var min_time := 0.5
@export var max_time := 1.0

func random_start():
	start(randf_range(min_time, max_time))
