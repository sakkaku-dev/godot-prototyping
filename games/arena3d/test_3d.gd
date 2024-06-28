extends Node3D

func _ready():
	InputMapper.override_key_inputs({
		"move_up": KEY_W,
		"move_down": KEY_S,
		"move_left": KEY_A,
		"move_right": KEY_D,

		"jump": KEY_SPACE,
		"run": KEY_SHIFT,
		"roll": KEY_CTRL,
	})
