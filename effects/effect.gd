class_name Effect
extends Node

signal finished()

var tw: Tween

func _new_tween():
	if tw and tw.is_running():
		tw.kill()
	
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.finished.connect(func(): finished.emit())
