class_name TypedWord
extends RichTextLabel

signal typing(typed, remaining)
signal type_finish()
signal type_start()
signal type_cancel()

@export var highlight_color := Color("0084d3")
@export var highlight_first := false

var word = "":
	set(v):
		word = v.to_lower()
		typed = ""
		update_word()
var typed = "":
	set(v):
		typed = v
		update_word()
		if typed == word:
			type_finish.emit()
		typing.emit(typed)
var focused := false:
	set(v):
		focused = v
		add_theme_color_override("font_outline_color", highlight_color if focused else Color.BLACK)

func _ready():
	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_OFF
	self.focused = false
	
	add_theme_constant_override("outline_size", 5)

func update_word():
	if highlight_first and typed.length() == 0:
		text = "[center][typed until=1 colored=false]%s[/typed][/center]" % word
	else:
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
	self.focused = true

func reset():
	self.word = word
	self.focused = false
	type_cancel.emit()
