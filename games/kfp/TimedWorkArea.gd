class_name TimedWorkArea
extends WorkArea

@export var work_timer: WorkTimer

var working_chicken

func _ready():
	super._ready()
	interact.interacted.connect(func(a): work_timer.stop_work())

func do_action(hand: Hand):
	if can_work(hand):
		work_timer.start_work()
		working_chicken = hand

func can_work(hand: Hand):
	return true
