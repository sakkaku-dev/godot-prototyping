extends Sprite3D

@export var text = ""

func _ready() -> void:
	$SubViewport/Label.text = text
