class_name KoyoriTimer
extends Timer

@export var player: CharacterBody2D
@export var allow_wall_jump := false

var has_contact := false

func _physics_process(delta):
	if has_contact and not _is_on_contact() and is_stopped():
		start()
	
	has_contact = _is_on_contact()

func _is_on_contact():
	return player.is_on_floor() or (allow_wall_jump and player.is_on_wall())

func can_jump():
	return _is_on_contact() or not is_stopped()
