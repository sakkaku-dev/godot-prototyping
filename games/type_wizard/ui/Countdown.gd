class_name Countdown
extends Label

@export var timer: Timer

func _process(delta):
	if timer.is_stopped():
		return
	
	text = TimeUtil.seconds_to_string(timer.time_left)
