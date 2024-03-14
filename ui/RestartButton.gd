class_name RestartButton
extends Button

func _ready():
	pressed.connect(func(): get_tree().reload_current_scene())
