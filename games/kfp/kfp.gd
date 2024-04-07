extends Node2D

@export var egg_scene: PackedScene
@export var total_eggs_label: Label

@onready var place_marker = $PlaceMarker
@onready var ordering = $TileMap/Ordering
@onready var tile_map = $TileMap

var total_eggs := 0:
	set(x):
		total_eggs = x
		total_eggs_label.text = "%s" % total_eggs
		
var place_egg := false

func _on_egg_catch_game_total_eggs_collected(eggs):
	self.total_eggs += eggs

func _on_egg_action_pressed():
	if place_egg:
		_stop_place_eggs()
	else:
		place_egg = true
		place_marker.follow()
		
func _stop_place_eggs():
	place_egg = false
	place_marker.unfollow()

func _unhandled_input(event):
	if place_egg:
		if event.is_action_pressed("action"):
			if total_eggs <= 0:
				print("NO EGGS")
				return
			
			var egg = egg_scene.instantiate()
			ordering.add_child(egg)
			egg.global_position = tile_map.map_to_local(tile_map.local_to_map(get_global_mouse_position()))
			self.total_eggs -= 1
		elif event.is_action_pressed("cancel"):
			_stop_place_eggs()
			
