class_name CuttingBoard
extends TimedWorkArea

func _ready():
	super._ready()
	work_timer.timeout.connect(func(): working_chicken.hold_item("ITEM"))

func can_work(hand):
	return not hand.is_holding()
