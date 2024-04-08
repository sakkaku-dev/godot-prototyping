extends Node2D

signal total_eggs_collected(eggs)

@export var interactable: Interactable
@export var game_scene: PackedScene
@export var mini_game: MiniGame

func _ready():
	interactable.interacted.connect(func(_x):
		var game = game_scene.instantiate()
		game.collected_eggs.connect(_on_eggs_collected)
		mini_game.start_game(game)
	)

func _on_eggs_collected(eggs: int):
	total_eggs_collected.emit(eggs)
	mini_game.hide_game()
