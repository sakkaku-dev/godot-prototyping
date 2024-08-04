class_name CuttingBoard
extends TimedWorkArea

const BOARD_GROUP = "CuttingBoard"

var order := -1

func _ready():
	add_to_group(BOARD_GROUP)
	super._ready()
	
	work_timer.timeout.connect(func():
		KfpManager.finish_order(order)
		var next_oder = KfpManager.next_open_order()
		if next_oder > 0:
			start_action(next_oder)
	)
	KfpManager.order_received.connect(func(id):
		if work_timer.is_stopped():
			start_action(id)
	)

func start_action(id: int):
	print("Received order %s" % id)
	order = id
	super.do_action(null)

func can_work(hand):
	return KfpManager.next_open_order() > 0
