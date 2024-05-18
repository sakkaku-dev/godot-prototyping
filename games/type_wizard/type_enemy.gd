extends CharacterBody2D

signal finished()
signal entered()

@export var speed := 20

@onready var rich_text_label = $RichTextLabel
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

var word = ""
var typed := ""
var highlighted := false

func _physics_process(delta):
	var dir = global_position.direction_to(Vector2.ZERO)
	velocity = dir * speed
	move_and_slide()

func _ready():
	_update_word()
	visible_on_screen_notifier_2d.screen_entered.connect(func(): entered.emit())
	finished.connect(func(): queue_free())

func _update_word():
	rich_text_label.text = "[center][typed until=%s]%s[/typed][/center]" % [typed.length(), word]

func handle_key(key: String):
	if typed.length() == word.length():
		return
	
	var next_word_char = word[typed.length()]
	if next_word_char == key.to_lower():
		typed += key.to_lower()
		_update_word()
		if typed == word:
			finished.emit()

func highlight():
	rich_text_label.add_theme_constant_override("outline_size", 5)
	highlighted = true
