class_name WorkTimer
extends Timer

var started_work := false

func _ready():
	timeout.connect(func():
		started_work = false
		paused = false
	)

func start_work():
	if not started_work:
		start()
		started_work = true

	paused = false

func stop_work():
	paused = true
