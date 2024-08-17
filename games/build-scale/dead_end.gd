extends Area3D

func _ready() -> void:
	body_entered.connect(func(body):
		body.hit_deadend()
	)
