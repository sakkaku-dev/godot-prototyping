class_name ToggleButton
extends BaseButton

@export var node: Control

func _ready() -> void:
	node.hide()
	pressed.connect(func(): node.visible = not node.visible)

func _unhandled_input(event: InputEvent) -> void:
	if node.visible and event.is_action_pressed("ui_cancel"):
		node.hide()
