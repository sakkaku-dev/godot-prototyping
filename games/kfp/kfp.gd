extends Node2D

@export var total_eggs_label: Label

var total_eggs := 0

func _on_egg_catch_game_total_eggs_collected(eggs):
	total_eggs += eggs
	total_eggs_label.text = "%s" % total_eggs
