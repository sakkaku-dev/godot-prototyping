class_name Dialog
extends Control

signal closed()

@export var pause: PauseBlur
@export var key_reader: KeyReader

var tw: Tween

func _ready():
	pivot_offset = size / 2
	hide()
	if key_reader:
		key_reader.pressed_key.connect(handle_key)

func open():
	show()
	process_mode = Node.PROCESS_MODE_ALWAYS
	pivot_offset = size / 2
	pause.pause()
	
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)

	pivot_offset = size / 2
func close():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tw.finished
	pause.resume()
	closed.emit()
	process_mode = Node.PROCESS_MODE_INHERIT

func handle_key(key: String, shift: bool):
	pass
