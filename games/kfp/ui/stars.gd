class_name Stars
extends Control

@export var connect_to_global := false

func _ready() -> void:
	if connect_to_global:
		KfpManager.stars_changed.connect(update)
	update()

func update(stars = KfpManager.stars):
	for i in get_child_count():
		var enable = i < stars
		get_child(i).modulate = Color.WHITE if enable else Color.DIM_GRAY
