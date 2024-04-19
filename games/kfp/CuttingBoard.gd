class_name CuttingBoard
extends TimedWorkArea

const BOARD_GROUP = "CuttingBoard"

func _ready():
	add_to_group(BOARD_GROUP)
	super._ready()
	work_timer.timeout.connect(func(): working_chicken.hold_item("ITEM"))

func can_work(hand):
	return not hand.is_holding()
