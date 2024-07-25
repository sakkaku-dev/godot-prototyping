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
			awaiting_hook = false
			
			var fish = []
			for f in body.fish:
				fish.append(f.fish)
				f.queue_free()
			caught_fish.emit(fish)
			body.remove()
