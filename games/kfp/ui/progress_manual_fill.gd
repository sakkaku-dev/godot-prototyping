class_name ProgressManualFill
extends ColorRect

func _ready() -> void:
	material = material.duplicate()

func set_fill(v: float):
	var shader = material as ShaderMaterial
	shader.set_shader_parameter("fill", v)
