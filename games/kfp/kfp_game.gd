extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var farm: Farm = $Game/Farm
@onready var restaurant: Restaurant = $Game/Restaurant
@onready var game: Node2D = $Game

var tw: Tween

func _ready():
	show_farm()
	farm.move_to_restaurant.connect(func(): show_restaurant())
	restaurant.move_to_farm.connect(func(): show_farm())
	
func show_farm():
	#if tw and tw.is_running(): return
	#
	#tw = create_tween()
	#tw.tween_property(game, "global_position", global_position - farm.global_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	camera_2d.global_position = farm.global_position
	farm.canvas_layer.show()
	restaurant.canvas_layer.hide()

func show_restaurant():
	#if tw and tw.is_running(): return
	#
	#tw = create_tween()
	#tw.tween_property(game, "global_position", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	camera_2d.global_position = restaurant.global_position
	farm.canvas_layer.hide()
	restaurant.canvas_layer.show()
