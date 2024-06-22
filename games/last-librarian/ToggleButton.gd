extends TextureButton

@export var control: Control

var tw: Tween

func _ready():
	toggle_mode = true
	
	pivot_offset = size / 2
	mouse_entered.connect(func(): _focus_in())
	mouse_exited.connect(func(): _focus_out())
	_focus_out()
	
	control.hide()
	toggled.connect(func(on):
		if not control.has_method("open") or not control.has_method("close"):
			return
	
		if on:
			control.open()
		else:
			control.close()
	)

func _focus_in():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)
	tw.tween_property(self, "modulate", Color.WHITE, 0.5)

func _focus_out():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2.ONE, 0.5)
	tw.tween_property(self, "modulate", Color.DIM_GRAY, 0.5)
