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
@onready var room_manager: RoomManager = get_tree().get_first_node_in_group(RoomManager.GROUP)

func _ready():
	typed_word.word = WORDS[dir]
	typed_word.type_finish.connect(func(): move.emit(dir))
	
	update()

func update():
	typed_word.reset()
	visible = dir in room_manager.get_linked_dirs()
