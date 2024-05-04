class_name Hand3D extends Area3D

@export var hold_point: Node3D

signal interacted(obj)
signal hold(item)

#var closest: Interactable3D
var holding: Interactable3D:
	set(v):
		if holding:
			holding.hold_release()
		
		holding = v
		
		if holding:
			holding.hold()
		
		hold.emit(holding)

func is_holding():
	return holding != null

func interact():
	if is_holding(): return
	self.holding = _get_closest_interactable()

func place(pos: Vector3):
	if not is_holding(): return
	holding.place(pos)
	self.holding = null

func _process(_delta):
	#closest = _get_closest_interactable()
	if holding:
		holding.get_object().global_position = hold_point.global_position

func _get_closest_interactable():
	var closest_item = null
	var closest_item_dot_scale = -1
	
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

