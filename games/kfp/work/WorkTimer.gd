class_name WorkTimer
extends Timer

@onready var initial_time := wait_time

var started_work := false

func _ready():
	one_shot = true
	timeout.connect(func():
		started_work = false
		paused = false
	)

func start_work(chicken: ChickenResource):
	wait_time = initial_time * ChickenTraits.get_working_speed_multipler(chicken.traits[0])
	
	if not started_work:
		start()
		started_work = true

	paused = false

func stop_work():
	paused = true
