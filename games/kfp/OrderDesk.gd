extends Area2D

signal ordered(c)

@export var interact: Interactable

var customer: Customer

func _ready():
	body_entered.connect(func(c):
		customer = c
	)

	interact.interacted.connect(func(_a):
		if not customer.is_ordering():
			print("Customer is not ordering anymore")
			return
		
		ordered.emit(customer)
	)
