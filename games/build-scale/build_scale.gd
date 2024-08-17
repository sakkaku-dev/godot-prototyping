extends Node2D

@onready var camera_3d: Camera3D = $CoinFall/Camera3D

func _ready() -> void:
	InputMapper.override_key_inputs({
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"move_up": [KEY_W],
		"move_down": [KEY_S],
		"attack": [MOUSE_BUTTON_LEFT],
		"jump": [KEY_SPACE]
	})

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		camera_3d.setup_target()
