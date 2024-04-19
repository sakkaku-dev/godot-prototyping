class_name CircleTimer
extends CanvasItem

@export var timer: Timer
@export var property := "fill"
@export var hide_on_stop := true

func _ready():
	material = material.duplicate()

func _process(delta):
	
	if hide_on_stop and timer != null:
		visible = not timer.is_stopped()
	else:
		_set_value(0.0)
	
	if timer == null or timer.is_stopped():
		return
	
	var p = timer.time_left / timer.wait_time
	_set_value(p)

func _set_value(p):
	var mat = material as ShaderMaterial
	mat.set_shader_parameter(property, p)
