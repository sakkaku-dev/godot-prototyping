class_name FocusControl
extends Node

@export var show_on_focus: Control
@onready var ctrl: Control = get_parent()

func _ready():
	ctrl.mouse_entered.connect(func(): ctrl.grab_focus())
	ctrl.focus_entered.connect(func():
		if show_on_focus:
			show_on_focus.show()
	)
	ctrl.focus_exited.connect(func():
		if show_on_focus:
			show_on_focus.hide()
	)
	
	if show_on_focus:
		show_on_focus.hide()
