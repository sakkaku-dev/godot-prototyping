extends Node2D

@export var speed_label: Label

@onready var camera_2d = $Camera2D
@onready var player = $Player

func _ready():
	InputMapper.override_key_inputs({
		"move_up": [KEY_W],
		"move_down": [KEY_S],
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"jump": [KEY_SPACE],
		"boost": [KEY_SHIFT],
		"attack": []
	})

func _process(delta):
	camera_2d.global_position = Vector2(player.global_position.x + 200, -100)
	speed_label.text = "%s" % player.velocity.length()
	speed_label.modulate = Color.RED if player.has_boost() else Color.WHITE
