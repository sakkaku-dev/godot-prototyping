class_name Cashier
extends Interactable3D

@onready var customer_area: Area3D = $CustomerArea
@onready var action_icon: ActionIcon = $ActionIcon
@onready var chargeable: Chargeable = $Chargeable
@onready var active_area: Marker3D = $ActiveArea

var queue := []
var active_customer: ShopCustomer = null

func _ready() -> void:
	action_icon.hide()
	customer_area.body_entered.connect(func(_b): _process_next_customer())
	chargeable.charged.connect(func(): _process_customer())

func _process_customer():
	if queue.is_empty():
		return
	
	action_icon.hide()
	active_customer = queue.pop_front()
	active_customer.queueing = false
	active_customer.move_to(active_area.global_position)

func _process_next_customer():
	if queue.is_empty():
		action_icon.hide()
		return
	
	action_icon.show()

func add_to_queue(customer: ShopCustomer):
	queue.append(customer)
	return customer_area.global_position

func interact(hand: Hand3D):
	if queue.is_empty():
		return
	
	var customer = queue[0]
	customer.leave()
	queue.pop_front()

func action(hand: Hand3D, pressed: bool):
	if not action_icon.visible:
		return
	
	if pressed:
		chargeable.start()
	else:
		chargeable.stop()
