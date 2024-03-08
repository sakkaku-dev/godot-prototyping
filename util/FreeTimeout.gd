class_name FreeTimeout
extends Timer

@export var node: Node

func _ready():
	one_shot = true
	timeout.connect(func(): node.queue_free())
