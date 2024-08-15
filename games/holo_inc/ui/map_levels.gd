extends Control

@export var level_scene: PackedScene
@export var section := 0
@export var levels_per_section := 10

func _ready() -> void:
	_create_levels()

func _create_levels():
	for i in range(levels_per_section):
		var level = level_scene.instantiate()
		level.level = section * levels_per_section + i
		add_child(level)
