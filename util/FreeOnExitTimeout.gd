class_name FreeOnExitTimeout
extends VisibleOnScreenNotifier2D

@export var free_timeout: Timer
@onready var node := get_parent()

func _ready():
	if free_timeout:
		free_timeout.timeout.connect(func(): node.queue_free())
	
	screen_exited.connect(func():
		if free_timeout:
			free_timeout.start()
		else:
			node.queue_free()
	)
	screen_entered.connect(func():
		if free_timeout:
			free_timeout.stop()
	)
