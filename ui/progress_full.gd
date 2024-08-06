class_name ProgressFill
extends ColorRect

@export var timer: Timer
@export var flipped := false

func _process(delta: float) -> void:
	if timer.is_stopped():
		return
	
	var p = timer.time_left / timer.wait_time
	if flipped:
		p = 1.0 - p
	_set_value(p)

func _set_value(v):
	var shader = material as ShaderMaterial
	shader.set_shader_parameter("fill", v)
