extends Node2D

const WORDS = {
	Vector2i.LEFT: "left",
	Vector2i.RIGHT: "right",
	Vector2i.UP: "up",
	Vector2i.DOWN: "down",
}

signal move(dir)

@export var dir := Vector2i.LEFT
@onready var typed_word = $TypedWord

func _ready():
	typed_word.word = WORDS[dir]
	typed_word.type_finish.connect(func(): move.emit(dir))

func update(show: bool):
	typed_word.reset()
	typed_word.enabled = show
	visible = show
