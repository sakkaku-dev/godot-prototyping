extends Node

signal money_changed()
signal aquarium_changed()

@export var unlocked_hooks: Array[HookResource] = []
@export var max_aquarium_capacity := 10

var aquarium := []

var money := 0:
	set(v):
		money = v
		money_changed.emit()

func update_fish_to_aquarium(add: Array, remove: Array):
	for f in remove:
		aquarium.erase(f)
		
	aquarium.append_array(add)
	aquarium_changed.emit()

func go_to_aquarium():
	get_tree().change_scene_to_file("res://games/rogue-fishing/aquarium.tscn")
	
func go_to_fishing():
	get_tree().change_scene_to_file("res://games/rogue-fishing/rogue_fishing.tscn")
