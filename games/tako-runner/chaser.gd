extends Node2D

@export var speed_label: Label
@export var distance_label: Label
@export var game_over: Control
@export var lose_distance := 5000

@onready var camera_2d = $Camera2D
@onready var player = $Player
@onready var bijou = $Bijou

func _ready():
	get_tree().paused = false
	game_over.hide()
	
	InputMapper.override_key_inputs({
		"move_up": [],
		"move_down": [],
		"move_left": [KEY_A],
		"move_right": [KEY_D],
		"jump": [KEY_SPACE],
		"boost": [KEY_SHIFT],
		"attack": [MOUSE_BUTTON_LEFT],
	})

func _process(delta):
	camera_2d.global_position = Vector2(player.global_position.x + 200, -100)
	speed_label.text = "Speed: %s" % player.velocity.length()
	speed_label.modulate = Color.RED if player.has_boost() else Color.WHITE

	var dist = player.global_position.distance_to(bijou.global_position)
	distance_label.text = "Dist: %s" % int(dist)
	
	if dist >= lose_distance:
		game_over.show()
		get_tree().paused = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
