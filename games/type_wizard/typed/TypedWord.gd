class_name TypedWord
extends RichTextLabel

signal typing()
signal type_finish()
signal type_start()

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
var hit := 0:
	set(v):
		hit = v
		hit += _get_num_of_spaces(hit)
		update_word()

var focused := false:
	set(v):
		focused = v
		add_theme_color_override("font_outline_color", highlight_color if focused else Color.BLACK)
		update_word()

func _ready():
	self.focused = false
	add_theme_constant_override("outline_size", 5)

func get_remaining_word():
	return word.substr(typed.length())

func is_fully_hit():
	return hit >= word.length()

func update_word():
	if highlight_first and typed.length() == 0:
		text = "[center][typed until=1 colored=false]%s[/typed][/center]" % word
	else:
		var color = Color.BLACK if focused else Color.DIM_GRAY
		text = "[center][typed until=%s hit=%s color=#%s jump=false]%s[/typed][/center]" % [typed.length(), hit, color.to_html(false), word]

func handle_key(key: String):
	if typed.length() >= word.length():
		return
	
	var next_word_char = word[typed.length()]
	if next_word_char == key.to_lower():
		if not focused:
			type_start.emit()
			self.focused = true
		
		typed += key.to_lower()
		typed += " ".repeat(_get_num_of_spaces(typed.length()))
		typing.emit()
		
		if typed == word:
			type_finish.emit()

func get_word():
	return word

func _get_num_of_spaces(from: int):
	if from >= word.length():
		return 0
	
	var next_word_char = word[from]
	var count = 0
	while next_word_char == " ":
		count += 1
		next_word_char = word[from + count]
	return count

func cancel():
	self.focused = false
	
func reset():
	self.word = word
	self.focused = false
