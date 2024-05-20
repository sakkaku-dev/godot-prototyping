class_name Manage
extends Dialog

signal next_wave()

@export var next_wave_btn: TypedWord

@onready var open_pos_x := position.x

func _ready():
	super._ready()
	
	closed.connect(func(): next_wave.emit())
	next_wave_btn.type_finish.connect(func(): close())
	
	next_wave_btn.word = "Next Wave"

func open():
	_pre_open()
	tw = TweenCreator.create(self, tw)
	
	position.x = open_pos_x + size.x
	tw.tween_property(self, "position:x", open_pos_x, 0.5)
	

func close():
	tw = TweenCreator.create(self, tw)
	tw.tween_property(self, "position:x", open_pos_x + size.x, 0.5)
	await tw.finished
	_post_close()

func handle_key(key: String, shift: bool):
	if shift:
		next_wave_btn.handle_key(key)
