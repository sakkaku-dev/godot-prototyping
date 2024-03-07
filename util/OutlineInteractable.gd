extends Node

@export var interactable: Interactable
@export var node: CanvasItem

func _ready():
	node.material = node.material.duplicate()
	_set_outline(false)
	
	interactable.enable_highlight.connect(_set_outline)
	
func _set_outline(enable: bool):
	var mat = node.material as ShaderMaterial
	mat.set_shader_parameter("enable", enable)
