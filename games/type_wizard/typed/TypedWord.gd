class_name TypedWord
extends RichTextLabel

const GROUP = "TypedWord"

signal typing()
signal type_finish()
signal type_start()

@export var independent := true
@export var text_color := Color.BLACK
@export var highlight_color := Color("0084d3")
@export var highlight_first := true
@export var jump := true

@onready var ninja: TypingNinja = get_tree().get_first_node_in_group(TypingNinja.GROUP)

@export var word = "":
	set(v):
		word = v.to_lower().strip_edges()
		typed = ""
		update_word()
var typed = "":
	set(v):
		typed = v
		update_word()
		
		if independent and typed == word and not emitted_finished:
			emitted_finished = true
			type_finish.emit()
var hit := 0:
	set(v):
		hit = v
		hit += _get_num_of_spaces(hit)
		while hit > typed.length():
			auto_type()
		
		update_word()
var emitted_finished := false

var focused := false:
	set(v):
		focused = v
		add_theme_color_override("font_outline_color", highlight_color if focused else Color.BLACK)
		update_word()

func _ready():
	self.focused = false
	if independent:
		add_to_group(GROUP)
	
	add_theme_constant_override("outline_size", 5)

func _process(delta):
	if ninja:
		self.focused = word.begins_with(ninja.typed) if ninja.typed != "" else false
		self.typed = ninja.typed if focused else ""

func get_remaining_word():
	return word.substr(typed.length())

func is_finished():
	return hit >= word.length()

func update_word():
	if highlight_first and typed.length() == 0:
		text = "[center][typed until=1]%s[/typed][/center]" % word
	else:
		text = "[center][typed until=%s jump=%s color=#%s]%s[/typed][/center]" % [typed.length(), jump, text_color.to_html(), word]

func _next_char():
	if typed.length() >= word.length():
		return null
	return word[typed.length()]

func auto_type():
	var char = _next_char()
	if char:
		handle_key(char, false)

func handle_key(key: String, grab_focus = true):
	var next_word_char = _next_char()
	if next_word_char == key.to_lower():
		if not focused and grab_focus:
			type_start.emit()
			self.focused = true
		
		typed += key.to_lower()
		typed += " ".repeat(_get_num_of_spaces(typed.length()))
		typing.emit()
		
		check_word()
		return true
	
	return false

func check_word():
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
	emitted_finished = false
