class_name ToggleHitBox
extends Node

@export var hitbox: HitBox
@export var attack_time := 0.1

func _ready():
	hitbox.monitoring = false

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		hitbox.monitoring = true
		await get_tree().create_timer(attack_time).timeout
		hitbox.monitoring = false
