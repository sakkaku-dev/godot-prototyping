class_name OrderDesk
extends WorkArea

signal ordered(c)

@export var customer_detect: Area2D
@export var icon: Node2D

var customer: Customer

func _ready():
	super._ready()
	icon.hide()
	
	customer_detect.body_entered.connect(func(c):
		customer = c
		icon.show()
	)

func do_action(_h):
	if not customer:
		print("No customer")
		return
	
	if not customer.is_ordering():
		print("Customer is not ordering anymore")
		return
	
	ordered.emit(customer)
	icon.hide()
