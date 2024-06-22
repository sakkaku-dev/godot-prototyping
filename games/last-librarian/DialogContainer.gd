class_name DialogContaier
extends Control

signal finished()

@export var all_text = []
@export var label: AutoTypedLabel

@export var open_ease := Tween.EASE_OUT
@export var open_duration := 1.0

@export var close_ease := Tween.EASE_IN_OUT
@export var close_duration := 2.0

var text_id := -1
var tw: Tween

func _ready():
	hide()

func close():
	tw = TweenCreator.create(self, tw).set_ease(close_ease).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, close_duration)
	get_tree().paused = false
	
	await tw.finished
	hide()

func open_with_text(text: Array):
	update_text(text)

	tw = TweenCreator.create(self, tw).set_ease(open_ease).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.WHITE, open_duration).from(Color.TRANSPARENT)
	show()
	get_tree().paused = true
	
	await tw.finished

func update_text(text: Array):
	text_id = -1
	all_text = text
	_show_next()

func is_transitioning():
	return tw and tw.is_running()

func _unhandled_input(event):
	if visible and event.is_action_pressed("continue") and not is_transitioning():
		_continue()

func _gui_input(event):
	if visible and event.is_action_pressed("continue") and not is_transitioning():
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
