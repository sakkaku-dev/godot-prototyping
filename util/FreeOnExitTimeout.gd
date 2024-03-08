class_name FreeOnExitTimeout
extends VisibleOnScreenNotifier2D

@export var free_timeout: FreeTimeout

func _ready():
	screen_exited.connect(func(): free_timeout.start())
	screen_entered.connect(func(): free_timeout.stop())
