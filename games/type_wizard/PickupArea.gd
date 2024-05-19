extends Area2D

signal picked_up(type)

func _ready():
	body_entered.connect(func(body):
		if not body is TypedDrop: return
		picked_up.emit(body.get_word())
		body.queue_free()
	)
