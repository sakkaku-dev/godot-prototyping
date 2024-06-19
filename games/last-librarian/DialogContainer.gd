class_name DialogContaier
extends Control

signal finished()

@export var all_text = []
@export var label: AutoTypedLabel

var text_id := -1

func _ready():
	hide()
	
	finished.connect(func():
		var out_tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		out_tw.tween_property(self, "modulate", Color.TRANSPARENT, 2.0)
		get_tree().paused = false
		
		await out_tw.finished
		hide()
	)

func show_text(text: Array):
	all_text = text
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.WHITE, 1.0).from(Color.TRANSPARENT)
	show()
	get_tree().paused = true
	
	_show_next()

func _unhandled_input(event):
	if event.is_action_pressed("continue"):
		_continue()

func _gui_input(event):
	if event.is_action_pressed("continue"):
		_continue()

func _continue():
	if not label.is_typing_finished():
		label.finish_type()
	else:
		_show_next()

func _show_next():
	text_id += 1
	if text_id < 0 or text_id >= all_text.size():
		finished.emit()
		return
	
	label.typed_text_for(all_text[text_id])
