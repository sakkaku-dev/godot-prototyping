class_name TimedWorkArea
extends WorkArea

@export var work_timer: WorkTimer

#var working_chicken

func _ready():
	super._ready()
	interact.interacted.connect(func(a): work_timer.stop_work())
	work_timer.timeout.connect(func(): work_finished.emit())

func do_action(hand: Hand):
	if can_work(hand):
		work_timer.start_work(worker)
		#working_chicken = hand

func can_work(hand: Hand):
	return true
