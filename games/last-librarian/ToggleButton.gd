extends TextureButton

@export var control: Control

func _ready():
	toggle_mode = true
	
	control.hide()
	toggled.connect(func(on):
		if not control.has_method("open") or not control.has_method("close"):
			return
	
		if on:
			control.open()
		else:
			control.close()
	)
