class_name ActionIcon
extends Sprite3D

@export var chargeable: Chargeable

func _ready() -> void:
	material_override = material_override.duplicate()

func set_fill(v: float):
	var mat = material_override as ShaderMaterial
	mat.set_shader_parameter("fill", v)

func show_icon(disabled = false):
	$Disabled.visible = disabled
	print("Disabled: %s" % disabled)
	show()

func _process(delta: float) -> void:
	if chargeable and chargeable.is_charging:
		set_fill(chargeable.value / chargeable.max_value)
