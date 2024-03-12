extends HitBox

signal finished()

@onready var timer = $Timer

func _ready():
	super._ready()
	timer.timeout.connect(func():
		finished.emit()
		queue_free()
	)
