class_name TypedWord
extends RichTextLabel

signal typing()
signal type_finish()
signal type_start()
signal type_cancel()

@export var highlight_color := Color("0084d3")
@export var highlight_first := false

var word = "":
	set(v):
		word = v.to_lower().strip_edges()
		typed = ""
		update_word()
var typed = "":
	set(v):
		typed = v
		update_word()
		
		if typed == word:
			type_finish.emit()
var hit := 0:
	set(v):
		hit = v
		hit += _get_num_of_spaces(hit)
		update_word()

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

func is_fully_hit():
	return hit >= word.length()

func update_word():
	if highlight_first and typed.length() == 0:
		text = "[center][typed until=1 colored=false]%s[/typed][/center]" % word
	else:
		text = "[center][typed until=%s hit=%s jump=false]%s[/typed][/center]" % [typed.length(), hit, word]

func handle_key(key: String):
	if typed.length() >= word.length():
		return
	
	var next_word_char = word[typed.length()]
	if next_word_char == key.to_lower():
		if typed == "":
			type_start.emit()
			_highlight()
		
		typed += key.to_lower()
		typed += " ".repeat(_get_num_of_spaces(typed.length()))
		typing.emit()

func _get_num_of_spaces(from: int):
	if from >= word.length():
		return 0
	
	var next_word_char = word[from]
	var count = 0
	while next_word_char == " ":
		count += 1
		next_word_char = word[from + count]
	return count

func _highlight():
	self.focused = true

func reset():
	self.word = word
	self.focused = false
	type_cancel.emit()
