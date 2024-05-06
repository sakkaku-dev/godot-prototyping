class_name Hand3D extends Area3D

func interact():
	var interactable = get_interactable()
	if interactable:
		interactable.interact()
		
	return interactable != null
	
func get_interactable() -> Interactable3D:
	for area in get_overlapping_areas():
		if area is Interactable3D:
			return area
	return null
