class_name Hand3D extends Area3D

signal picked_up_at(pos: Vector3)

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

func hold_item(i, pos = Vector3.ZERO):
	item = i
	picked_up_at.emit(pos)
	print("Holding item %s" % i.get_name())

func is_holding_item():
	return item != null

func take_item():
	var x = item
	item = null
	return x
