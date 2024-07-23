class_name CollectArea
extends Area2D

signal caught_fish(fish)

var awaiting_hook  = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_exited(body: Node2D):
	if body is Hook:
		awaiting_hook = true

func _on_body_entered(body: Node2D):
	if body is Hook:
		if awaiting_hook:
			body.remove()
			awaiting_hook = false
	elif body is Fish:
		caught_fish.emit(body.fish)
		body.queue_free()
