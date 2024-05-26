extends Node2D

@export var spawner: EnemySpawner
@export var ninja: TypingNinja
@export var random_timer: RandomTimer

@onready var key_reader = $KeyReader

func _ready():
	key_reader.pressed_key.connect(_pressed_key)
	key_reader.pressed_cancel.connect(_pressed_cancel)

func _pressed_cancel(_shift: bool):
	ninja.reset()

func _pressed_key(key: String, _shift: bool):
	ninja.typing(key)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		random_timer.start()
