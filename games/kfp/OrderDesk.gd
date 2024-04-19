class_name OrderDesk
extends TimedWorkArea

const ORDER_GROUP = "OrderDesk"

signal ordered(c)

@export var customer_queue: CustomerQueue
@export var icon: Node2D

var customer: Customer

func _ready():
	add_to_group(ORDER_GROUP)
	super._ready()
	icon.hide()
	
	customer_queue.awaiting_order.connect(func(): icon.show())
	work_timer.timeout.connect(func():
		var customer = customer_queue.get_first_customer()
		
		if not customer:
			print("No customer")
			return
		
		if not customer.is_ordering():
			print("Customer is not ordering anymore")
			return
		
		ordered.emit(customer)
		icon.hide()
		customer_queue.processed_customer()
	)

func can_work(_hand):
	return customer_queue.has_customers()

func has_customers():
	return customer.has_customers()
