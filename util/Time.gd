class_name TimeUtil

static func seconds_to_string(secs: float):
	return _to_time(secs) 

static func _to_time(time_in_sec):
	var minutes: int= floor(time_in_sec / 60)
	var seconds: int = time_in_sec - minutes * 60
	return "%s:%s" % [_time_str(minutes), _time_str(seconds)]
	
static func _time_str(time: int):
	if time < 10:
		return "0%s" % time
	return "%s" % time
