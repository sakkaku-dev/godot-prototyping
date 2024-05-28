extends Node2D

signal picked_up()

@onready var typed_word = $TypedWord

func _ready():
	hide()

	visibility_changed.connect(func(): typed_word.enabled = visible)
	typed_word.type_finish.connect(func():
		picked_up.emit()
		hide()
	)

func set_word(w):
	typed_word.word = w
	show()
