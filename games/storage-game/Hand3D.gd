class_name Hand3D extends Area3D

var item

func interact():
	var interactable = get_interactable()
	if interactable:
		interactable.interact(self)
		return true
		
	return false

func action(pressed: bool):
	var interactable = get_interactable()
	if interactable:
		interactable.action(self, pressed)
		return true
		
	return false
	
func get_interactable() -> Interactable3D:
	for area in get_overlapping_areas():
		if area is Interactable3D:
			return area
	return null

func hold_item(i):
	item = i
	print("Holding item %s" % i.get_name())

func is_holding_item():
	return item != null

func take_item():
	var x = item
	item = null
	return x
