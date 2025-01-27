class_name OrderDesk
#extends TimedWorkArea
#
#const ORDER_GROUP = "OrderDesk"
#
#@export var customer_queue: CustomerQueue
#@export var icon: Node2D
#
#var customer: Customer
#
#func _ready():
	#add_to_group(ORDER_GROUP)
	#super._ready()
	#icon.hide()
	#
	#customer_queue.awaiting.connect(func(show):
		#icon.visible = show
		#if worker and show:
			#print("Taking customer order")
			#do_action(null)
	#)
	#work_timer.timeout.connect(func():
		#icon.hide()
		#
		#var customer = customer_queue.get_first_customer()
		#if not customer:
			#print("No customer")
			#return
		#
		#if not KfpManager.has_supply_left():
			#print("No supply left")
			#customer.leave_unhappy()
			#return
		#
		#if customer.order_id > 0:
			#print("Takeout finished")
			#customer.finish_order()
			#return
		#
		#if not customer.is_ordering():
			#print("Customer is not ordering anymore")
			#return
		#
		#customer.taken_order(KfpManager.add_new_order())
		#print("Taken order: %s" % customer.order_id)
	#)
	#
	#KfpManager.order_prepared.connect(func(id):
		#var customer = customer_queue.get_first_customer()
		#if customer and customer.order_id == id:
			#print("Preparing takeout")
			#icon.show()
			#do_action(null)
	#)
#
#func can_work(_hand):
	#return customer_queue.has_customers()
