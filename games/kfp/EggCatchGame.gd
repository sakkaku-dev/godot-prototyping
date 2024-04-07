extends Node2D

signal total_eggs_collected(eggs)

@export var interactable: Interactable
@export var game_ui: Control

@export var game_scene: PackedScene
@export var game_container: SubViewport

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_hide_game(true)
	
	interactable.interacted.connect(func(_x):
		get_tree().paused = true
		
		game_ui.pivot_offset = game_ui.size / 2
		game_ui.scale = Vector2.ZERO
		game_ui.show()
		
		game_ui.process_mode = Node.PROCESS_MODE_ALWAYS
		var game = game_scene.instantiate()
		game.collected_eggs.connect(_on_eggs_collected)
		game_container.add_child(game)
		
		var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(game_ui, "scale", Vector2.ONE, 0.5)
		await tw.finished
		
	)

func _hide_game(init = false):
	game_ui.process_mode = Node.PROCESS_MODE_DISABLED
	for c in game_container.get_children():
		game_container.remove_child(c)

	if not init:
		var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(game_ui, "scale", Vector2.ZERO, 0.5)
		await tw.finished
		
	game_ui.hide()

func _on_eggs_collected(eggs: int):
	_hide_game()
	total_eggs_collected.emit(eggs)
	get_tree().paused = false
