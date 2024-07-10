extends Node2D

signal finished()

@export var times := 1

var tw: Tween
var called := 0

func _ready():
	modulate = Color.TRANSPARENT
	tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops()
	
	tw.tween_property(self, "modulate", Color.WHITE, 0.3)
	tw.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 0.5)
	tw.tween_callback(func():
		called += 1
		if called >= times:
			finished.emit()
			queue_free()
	)
