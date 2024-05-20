class_name Manage
extends Control

var tw: Tween

@onready var open_pos_x := position.x

func _ready():
	hide()

func open():
	tw = TweenCreator.create(self, tw)
	
	position.x = open_pos_x + size.x
	show()
	tw.tween_property(self, "position:x", open_pos_x, 0.5)

func close():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "position:x", open_pos_x + size.x, 0.5)
