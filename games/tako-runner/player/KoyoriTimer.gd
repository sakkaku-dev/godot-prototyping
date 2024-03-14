class_name KoyoriTimer
extends Timer

@export var player: CharacterBody2D

var was_on_floor := false

func _physics_process(delta):
	if was_on_floor and not player.is_on_floor() and is_stopped():
		start()
	
	was_on_floor = player.is_on_floor()

func can_jump():
	return player.is_on_floor() or not is_stopped()
