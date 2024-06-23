extends Control

@export var restart_button: Button
@export var label: Label

var tw: Tween

func _ready():
	restart_button.pressed.connect(func(): get_tree().reload_current_scene())
	
	hide()
	modulate = Color.TRANSPARENT

func open(won: bool):
	label.text = "Humanity has survived" if won else "Humanity has gone extinct"
	show()
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate", Color.WHITE, 1.0)
