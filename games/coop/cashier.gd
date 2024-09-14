class_name Cashier
extends Interactable3D

signal money_received(money: int)

@onready var customer_area: Area3D = $CustomerArea
@onready var action_icon: ActionIcon = $ActionIcon
@onready var chargeable: Chargeable = $Chargeable

var queue := []
var menu := [PotionItem.Type.POTION_RED, PotionItem.Type.POTION_BLUE, PotionItem.Type.POTION_GREEN]

func _ready() -> void:
	action_icon.hide()
	customer_area.body_entered.connect(func(_b): _process_next_customer())
	chargeable.charged.connect(func(): _set_new_order())

func _set_new_order():
	if queue.is_empty():
		print("No customers for setting order")
		return
	
	var order = menu.pick_random()
	print("New order for %s" % PotionItem.Type.keys()[order])
	queue[0].set_order(order)
	action_icon.hide()

func _process_next_customer():
	if queue.is_empty():
		action_icon.hide()
		print("No customers for processing")
		return
	
	action_icon.show()

func add_to_queue(customer: ShopCustomer):
	queue.append(customer)
	return customer_area.global_position

func interact(hand: Hand3D):
	if queue.is_empty():
		print("No customers at cashier")
		return
	
	if not hand.is_holding_item():
		print("Not holding any items to give customers")
		return
	
	var customer = queue[0]
	if customer.ordering_item < 0:
		print("Customer still has not ordered anything")
		return
	
	if customer.ordering_item != hand.item.type:
		print("Wrong order for customer")
		return
	
	money_received.emit(hand.item.get_price())
	hand.take_item()
	customer.leave()
	queue.pop_front()

func action(hand: Hand3D, pressed: bool):
	if not action_icon.visible:
		print("No action available at cashier")
		return
	
	if pressed:
		chargeable.start()
	else:
		chargeable.stop()
