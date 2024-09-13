class_name Ingredient
extends Interactable3D

@export var type := PotionItem.Type.FEATHER

func interact(hand: Hand3D):
	var item = PotionItem.Type.keys()[type]
	if hand.is_holding_item():
		print("Already holding an item. Cannot pickup %s" % item)
		return false
	
	hand.hold_item(PotionItem.new(type))
	print("Taking Item %s" % item)
	return true
