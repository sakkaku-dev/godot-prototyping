class_name Cauldron
extends Interactable3D

@export var chargeable: Chargeable
@export var icon: ActionIcon
@export var ingredients: Sprite3D
@export var label: Label

var items := []
var last_hand: Hand3D

func _ready():
	reset()
	
	chargeable.charged.connect(func():
		var potion = PotionItem.find_recipe(items)
		items.clear()
		_update_ingredients()
		
		if not potion:
			print("Failed to mix potion")
			return
			
		if last_hand == null:
			print("Couldn't put potion to someone's hand")
			return
		
		last_hand.hold_item(PotionItem.new(potion))
	)
	chargeable.charging_started.connect(func():
		icon.show()
		ingredients.hide()
	)
	chargeable.charging_stopped.connect(func():
		icon.hide()
		ingredients.show()
	)

func interact(hand: Hand3D):
	if pickupable:
		if hand.is_holding_item():
			print("Player is holding an item, but shouldn't be possible")

		hand.hold_item(GridItem.new(GridItem.Type.CAULDRON, {"items": items}), global_position)
		queue_free()
		return
	
	if is_someone_else_working(hand):
		print("Someone is already working on it")
		return
	
	if not hand.is_holding_item():
		print("No items in hand")
		return
	
	items.append(hand.take_item())
	_update_ingredients()
	print("Items inside: %s" % [items.map(func(x): return x.get_name())])

func _update_ingredients():
	label.text = "%sx" % items.size()
	ingredients.show()

func is_someone_else_working(hand: Hand3D):
	return last_hand != null and last_hand != hand

func action(hand: Hand3D, pressed: bool):
	if pickupable:
		print("In pickup mode")
		return
	
	if is_someone_else_working(hand):
		print("Someone is already working on it")
		return
	
	if items.is_empty():
		print("No items in cauldron")
		return
	
	if hand.is_holding_item():
		print("Cannot mix cauldron with items on the hand")
		return
	
	if pressed:
		last_hand = hand
		chargeable.start()
	else:
		chargeable.stop()
		last_hand = null

func reset():
	items = []
	icon.hide()
	ingredients.hide()
