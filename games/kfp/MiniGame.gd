class_name MiniGame
extends Node

const GROUP = "MiniGame"

@export var game_ui: Control
@export var game_container: SubViewport

func _ready():
	hide_game(true)

func hide_game(init = false):
	game_ui.process_mode = Node.PROCESS_MODE_DISABLED
	for c in game_container.get_children():
		game_container.remove_child(c)

	if not init:
		var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(game_ui, "scale", Vector2.ZERO, 0.5)
		await tw.finished
		
	game_ui.hide()
	get_tree().paused = false

func start_game(game_node):
	get_tree().paused = true
	
	game_ui.pivot_offset = game_ui.size / 2
	game_ui.scale = Vector2.ZERO
	game_ui.show()
	
	game_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	game_container.add_child(game_node)
	
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(game_ui, "scale", Vector2.ONE, 0.5)
