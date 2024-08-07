class_name TakeOut
extends TimedWorkArea

const TAKEOUT_GROUP = "TakeOut"

@export var queue: TakeOutQueue
@export var icon: Node2D

func _ready():
	add_to_group(TAKEOUT_GROUP)
	super._ready()
	icon.hide()
	
	queue.awaiting.connect(func(show):
		icon.visible = show
		if worker and show:
			print("Preparing takeout")
			do_action(null)
	)
	work_timer.timeout.connect(func(): 
		icon.hide()
		
		var customer = queue.get_first_customer()
		if not customer:
			print("No customer")
			return
		
		if customer.order_id <= 0:
			print("Customer who hasn't ordered is waiting for takeout for some reason !?!?!")
			return
		
		customer.finish_order()
		print("Finishing takeout for order %s" % customer.order_id)
	)
	
	KfpManager.order_prepared.connect(func(id): do_action(null))

func can_work(_hand):
	var customer = queue.get_first_customer()
	return customer != null and customer.order_id > 0 and KfpManager.is_order_ready_for_takeout(customer.order_id)
