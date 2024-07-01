class_name CollectArea
extends Area2D

signal caught_fish(fish)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is Hook:
		body.remove()
	elif body is Fish:
		caught_fish.emit(body.fish)
		body.queue_free()
