class_name SlideEffect
extends Node

@export var control: Control

var tw: Tween

func _create_tw(prev_tw: Tween):
	if prev_tw and prev_tw.is_running():
		prev_tw.kill()
	
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func do_show():
	tw = _create_tw(tw)
	tw.tween_property(control, "position", Vector2.ZERO, 0.5).from(control.size * Vector2.UP)
	control.show()

func do_hide():
	tw = _create_tw(tw)
	tw.tween_property(control, "position", control.size * Vector2.UP, 0.5)
