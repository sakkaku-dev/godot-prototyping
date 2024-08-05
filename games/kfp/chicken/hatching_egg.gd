class_name HatchingEgg
extends Node2D

signal hatched()

const GROUP = "HatchingEgg"

@export var timer: Timer
#@export var interactable: Interactable
#@export var game_scene: PackedScene

#@onready var mini_game: MiniGame = get_tree().get_first_node_in_group(MiniGame.GROUP)

var coord := Vector2i.ZERO
#var is_playing := false

func _ready():
	add_to_group(GROUP)
	timer.timeout.connect(func(): hatched.emit())
	
	#interactable.interact_started.connect(func(_x):
		#var game = game_scene.instantiate()
		#game.current_time_left = timer.time_left
		#game.hatched.connect(_on_hatched)
		#mini_game.start_game(game)
		#is_playing = true
	#)

func _on_hatched():
	hatched.emit()
	#if is_playing:
		#mini_game.hide_game()
