class_name TypedCharacter
extends CharacterBody2D

signal finished()

@export var typed_word: TypedWord
@export var screen_notifier: VisibleOnScreenNotifier2D

@onready var wizard: Wizard = get_tree().get_first_node_in_group(Wizard.GROUP)

func _ready():
	typed_word.type_finish.connect(func(): finished.emit())
	typed_word.type_start.connect(func(): z_index = 20)

func handle_key(key: String):
	return typed_word.handle_key(key)

func set_word(word: String):
	typed_word.word = word.to_lower()

func get_word():
	return typed_word.word

func get_remaining_word():
	return typed_word.get_remaining_word()

func is_on_screen():
	if screen_notifier:
		return screen_notifier.is_on_screen()
	return true

func is_focused():
	return typed_word.focused
