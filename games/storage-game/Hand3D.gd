class_name Hand3D extends Area3D

signal interacted(obj)
signal hold(item)

var closest: Interactable3D

#func _ready():
	#area_exited.connect(func(a): a.unhighlight())

func interact():
	if can_interact():
		closest.interact(self)
		interacted.emit(closest)

func can_interact():
	return closest and monitoring

func _process(_delta):
	closest = _get_closest_interactable()
	#_update_hightlight()


#func _update_hightlight(disable = false):
	#if monitoring:
		#for area in get_overlapping_areas():
			#if area == closest and not disable:
				#area.highlight()
			#else:
				#area.unhighlight()

#func disable():
	#_update_hightlight(true)
	#monitoring = false
#
#func enable():
	#monitoring = true

func _get_closest_interactable():
	var closest_item = null
	var closest_item_dot_scale = -1
	if monitoring:
		for area in get_overlapping_areas():
			if closest_item == null:
				closest_item = area
			#else:
				#var item_dir = (area.global_position - global_position).normalized()
				#var hand_dir = Vector2.RIGHT * scale.x
				#var dot_scale = item_dir.dot(hand_dir)
#
				#if dot_scale > closest_item_dot_scale:
					#closest_item = area
					#closest_item_dot_scale = dot_scale

	return closest_item

