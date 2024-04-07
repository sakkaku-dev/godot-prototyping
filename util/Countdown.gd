class_name Countdown
extends Label

@export var timer: Timer

#func _ready():
	#timer = Timer.new()
	#timer.autostart = false
	#timer.one_shot = false
	#timer.wait_time = 1
	#add_child(timer)

func _process(delta):
	if timer.is_stopped():
		return
	
	_update_time(timer.time_left)

#func start_timer(time: int):
	#time_in_sec = time
	#timer.start()
	#_update_time()
#
#func add_time(time: int):
	#time_in_sec += time
	#_update_time()
#
#func _on_timeout():
	#time_in_sec -= 1
	#_update_time()
	#
	#if time_in_sec <= 0:
		#timeout.emit()
	
func _update_time(time_in_sec):
	var minutes: int= floor(time_in_sec / 60)
	var seconds: int = time_in_sec - minutes * 60
	text = "%s:%s" % [_time_str(minutes), _time_str(seconds)]
	
func _time_str(time: int):
	if time < 10:
		return "0%s" % time
	return "%s" % time
