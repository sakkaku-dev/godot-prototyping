class_name JumpBuffer
extends Timer

signal jump()

@export var player: CharacterBody2D
@export var allow_wall_jump := false

func _physics_process(delta):
	if is_stopped():
		return
	
	if player.is_on_floor() or (allow_wall_jump and player.is_on_wall()):
		jump.emit()

func buffer_jump():
	start()
