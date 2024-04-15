class_name OverlayEffect
extends Effect

@export var overlay: Control

func _ready():
	overlay.hide()
	overlay.modulate = Color.TRANSPARENT

func open():
	_new_tween()
	tw.tween_property(overlay, "modulate", Color.WHITE, 0.5)
	overlay.show()

func close():
	_new_tween()
	tw.tween_property(overlay, "modulate", Color.TRANSPARENT, 0.5)
	await tw.finished
	overlay.hide()
