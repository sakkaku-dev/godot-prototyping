extends Control

@export var start_text: Label

var tw: Tween

func _ready():
	hide()

func open():
	get_tree().paused = true
	show()
	
	tw = TweenCreator.create(self, tw).set_parallel(false)
	tw.tween_property(self, "modulate", Color.WHITE, 1.0).from(Color.TRANSPARENT).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(start_text, "modulate", Color.TRANSPARENT, 0.5).set_delay(3.0).set_ease(Tween.EASE_IN)
	await tw.finished
	
	close()

func close():
	get_tree().paused = false
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tw.finished
	hide()
