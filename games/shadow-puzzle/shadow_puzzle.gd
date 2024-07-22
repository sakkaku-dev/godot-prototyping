extends Node

func _ready():
	InputMapper.override_key_inputs({
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"move_up": [KEY_W],
		"move_down": [KEY_S],
		"interact": [KEY_SPACE],
		"inventory": [KEY_TAB],
		"action": [MOUSE_BUTTON_LEFT],
		"item_1": [KEY_1],
	})

