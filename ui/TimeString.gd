class_name TimeString
extends Label

func set_time(secs: float):
	text = TimeUtil.seconds_to_string(secs)
