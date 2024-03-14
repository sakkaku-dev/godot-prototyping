class_name JumpBuffer
extends Timer

signal jump()

@export var player: CharacterBody2D

func _physics_process(delta):
    if is_stopped():
        return
    
    if player.is_on_floor():
        jump.emit()

func buffer_jump():
    start()