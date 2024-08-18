extends Node2D

func _ready() -> void:
	get_tree().paused = false
	
	InputMapper.override_key_inputs({
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"attack": [MOUSE_BUTTON_LEFT],
		"jump": [KEY_SPACE]
	})

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://games/build-scale/coin_fall.tscn")
