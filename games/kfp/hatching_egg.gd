extends Node2D

signal hatched()

@export var timer: Timer
@export var interactable: Interactable
@export var game_scene: PackedScene
@export var mini_game: MiniGame

func _ready():
	timer.timeout.connect(func(): hatched.emit())
	
	interactable.interacted.connect(func(_x):
		var game = game_scene.instantiate()
		game.current_time_left = timer.time_left
		game.hatched.connect(_on_hatched)
		mini_game.start_game(game)
	)

func _on_hatched():
	hatched.emit()
	mini_game.hide_game()
