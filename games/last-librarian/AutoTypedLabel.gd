class_name AutoTypedLabel
extends RichTextLabel

@export var type_text_time := .02

var time := 0.0

func typed_text_for(txt: String):
	text = txt
	visible_characters = 0
	time = 0

func _process(delta):
	time += delta
	if time >= type_text_time:
		time = 0
		if not is_typing_finished():
			visible_characters += 1

func is_typing_finished():
	return visible_characters >= text.length()

func finish_type():
	visible_characters = text.length()
