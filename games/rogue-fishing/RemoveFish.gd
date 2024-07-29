extends Area2D

func _ready():
	body_entered.connect(func(x): x.queue_free())
