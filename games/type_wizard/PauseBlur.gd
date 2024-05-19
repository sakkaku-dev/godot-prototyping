class_name PauseBlur
extends ColorRect

@export var blur_value := 1.0

var tw: Tween

func _ready():
	hide()

func pause():
	show()
	get_tree().paused = true
	tw = TweenCreator.create(self, tw)
	tw.tween_method(func(v): material.set_shader_parameter("lod", v), 0.0, blur_value, 0.5)

func resume():
	get_tree().paused = false
	tw = TweenCreator.create(self, tw)
	tw.tween_method(func(v): material.set_shader_parameter("lod", v), material.get_shader_parameter("lod"), 0, 0.5)
	
