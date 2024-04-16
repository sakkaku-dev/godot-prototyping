class_name CircleTimer
extends ColorRect

@export var timer: Timer
@export var property := "fill"

func _ready():
	material = material.duplicate()

func _process(delta):
	visible = not timer.is_stopped()
	
	if timer.is_stopped():
		return
	
	var p = timer.time_left / timer.wait_time
	var mat = material as ShaderMaterial
	mat.set_shader_parameter(property, p)
