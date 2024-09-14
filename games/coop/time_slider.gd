extends HSlider

@export var timer: Timer

func _ready() -> void:
	max_value = 100

func _process(delta: float) -> void:
	if timer.is_stopped(): return
	value = max_value - (timer.time_left / timer.wait_time) * 100
