extends Node2D

@export var fish_scene: PackedScene
@export var back_btn: BaseButton

func _ready():
	back_btn.pressed.connect(func(): DeepwaterGame.go_to_fishing())
	
	for fish in DeepwaterGame.aquarium:
		var node = fish_scene.instantiate()
		node.fish = fish
		add_child(node)
