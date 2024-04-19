class_name TakeOut
extends TimedWorkArea

const TAKEOUT_GROUP = "TakeOut"

@export var queue: TakeOutQueue

func _ready():
	add_to_group(TAKEOUT_GROUP)
	super._ready()
	work_timer.timeout.connect(func(): 
		KFP.get_object(self).finished_order(working_chicken.item)
		working_chicken.hold_item(null)
	)

func can_work(hand: Hand):
	return hand.is_holding() and KFP.get_object(self).has_orders()

func has_customers():
	return queue.has_customers()
