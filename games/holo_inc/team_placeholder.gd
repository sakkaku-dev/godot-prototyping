extends Node2D

@onready var character: Sprite2D = $Character

var current_character: String:
	set(v):
		current_character = v
		character.visible = v != ""

func _ready() -> void:
	self.current_character = ""
