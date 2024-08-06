extends HSlider

@export var timer: Timer

func _process(delta: float) -> void:
	if timer.is_stopped(): return
	
	var p = timer.time_left / timer.wait_time
	value = (1.0 - p) * 100
