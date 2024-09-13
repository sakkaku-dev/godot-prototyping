extends Node3D

var shop_open := false

func _ready() -> void:
	InputMapper.override_key_inputs({
		"move_left": [KEY_A, InputMapper.joy_stick_x(-1)],
		"move_right": [KEY_D, InputMapper.joy_stick_x(1)],
		"move_up": [KEY_W, InputMapper.joy_stick_y(-1)],
		"move_down": [KEY_S, InputMapper.joy_stick_y(1)],
		"interact": [KEY_E, InputMapper.joy_btn(JOY_BUTTON_A)],
		"action": [KEY_SPACE, InputMapper.joy_btn(JOY_BUTTON_X)],
		"sprint": [KEY_SHIFT, InputMapper.joy_btn(JOY_BUTTON_B)],
	})
