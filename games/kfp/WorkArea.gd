class_name WorkArea
extends Area2D

const GROUP = "WorkArea"

var is_occupied := false

func _ready():
	add_to_group(GROUP)

func has_available_work():
	return not is_occupied

func lock_work():
	is_occupied = true
