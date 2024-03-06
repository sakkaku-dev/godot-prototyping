class_name Interactable
extends Area2D

signal enable_highlight(enable)
signal interacted

func highlight():
	enable_highlight.emit(true)

func unhighlight():
	enable_highlight.emit(false)

func interact():
	interacted.emit()
