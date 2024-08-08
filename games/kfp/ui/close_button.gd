extends Button

@export var node: Control

func _ready() -> void:
	pressed.connect(func(): node.hide())
