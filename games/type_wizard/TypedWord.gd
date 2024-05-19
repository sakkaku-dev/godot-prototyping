class_name TypedWord
extends RichTextLabel

signal typing(typed, remaining)
signal type_finish()
signal type_start()
signal type_cancel()

@export var highlight_color := Color("0084d3")

var word = "":
	set(v):
		word = v
		typed = ""
		update_word()
var typed = "":
	set(v):
		typed = v
		update_word()
		if typed == word:
			type_finish.emit()
		typing.emit(typed)

func _ready():
	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_OFF
	add_theme_constant_override("outline_size", 5)
	add_theme_color_override("font_outline_color", Color.BLACK)

func highlight_first():
	text = "[center][typed until=1 colored=false]%s[/typed][/center]" % word

func update_word():
	text = "[center][typed until=%s]%s[/typed][/center]" % [typed.length(), word]

func handle_key(key: String):
	if typed.length() == word.length():
		return
	
	var next_word_char = word[typed.length()]
	if next_word_char == key.to_lower():
		if typed == "":
			type_start.emit()
			_highlight()
		
		typed += key.to_lower()

func _highlight():
	add_theme_color_override("font_outline_color", highlight_color)

func reset():
	self.word = word
	add_theme_color_override("font_outline_color", Color.BLACK)
	type_cancel.emit()
