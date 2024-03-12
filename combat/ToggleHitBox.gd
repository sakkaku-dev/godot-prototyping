class_name ToggleHitBox
extends Node

@export var hitbox: HitBox
@export var attack_time := 0.1
@export var node: CanvasItem
@export var use_input := false

func _ready():
	hitbox.monitoring = false
	if node:
		node.hide()

func _unhandled_input(event):
	if use_input and event.is_action_pressed("attack"):
		attack()

func attack():
	hitbox.monitoring = true
	if node:
		node.show()
	await get_tree().create_timer(attack_time).timeout
	hitbox.monitoring = false
	if node:
		node.hide()
