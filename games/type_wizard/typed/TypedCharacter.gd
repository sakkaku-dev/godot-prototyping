class_name TypedCharacter
extends CharacterBody2D

signal finished()

@export var typed_word: TypedWord
@export var screen_notifier: VisibleOnScreenNotifier2D

func get_word():
	return typed_word.word

func is_on_screen():
	if screen_notifier:
		return screen_notifier.is_on_screen()
	return true

func is_focused():
	return typed_word.focused
