class_name TypedCharacter
extends CharacterBody2D

const GROUP = "TypedCharacter"

signal finished()

@export var typed_word: TypedWord
@export var screen_notifier: VisibleOnScreenNotifier2D

@onready var wizard: Wizard = get_tree().get_first_node_in_group(Wizard.GROUP)

var is_finished := false

func _ready():
	typed_word.type_finish.connect(func(): finished.emit())
	typed_word.type_start.connect(func(): z_index = 10)
	#typed_word.type_cancel.connect(func(): z_index = 0)
	finished.connect(func(): is_finished = true)
	add_to_group(GROUP)

func handle_key(key: String):
	typed_word.handle_key(key)

func set_word(word: String):
	typed_word.word = word.to_lower()

func get_word():
	return typed_word.word

func is_on_screen():
	if screen_notifier:
		return screen_notifier.is_on_screen()
	return true
