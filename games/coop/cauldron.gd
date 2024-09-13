class_name Cauldron
extends Interactable3D

@export var chargeable: Chargeable
@export var icon: ActionIcon
@export var ingredients: Sprite3D
@export var label: Label

var items := []
var last_hand: Hand3D

func _ready():
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
	
	icon.hide()
	ingredients.hide()
	
	chargeable.charging_started.connect(func():
		icon.show()
		ingredients.hide()
	)
	chargeable.charging_stopped.connect(func():
		icon.hide()
		ingredients.show()
	)

func interact(hand: Hand3D):
	if is_someone_else_working(hand):
		print("Someone is already working on it")
		return
	
	if not hand.is_holding_item():
		#hand.hold_item(self)
		#queue_free()
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
