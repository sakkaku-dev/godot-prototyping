class_name Hand extends Area2D

signal interact_started()
signal interacted(obj)
signal hold(item)

var closest: Interactable
var interacting := false
var item

func _ready():
	collision_mask = 0
	collision_layer = 0
	set_collision_mask_value(Interactable.INTERACTABLE_LAYER, true)
	
	area_exited.connect(func(a): a.unhighlight())

func interact_start():
	if can_interact():
		closest.interact_start(self)
		interacting = true
		interact_started.emit(closest)

func interact():
	if can_interact():
		closest.interact(self)
		interacting = false
		interacted.emit(closest)

func can_interact():
	return closest and monitoring

func _process(_delta):
	closest = _get_closest_interactable()
	_update_hightlight()


func _update_hightlight(disable = false):
	if monitoring:
		for area in get_overlapping_areas():
			if area == closest and not disable:
				area.highlight()
			else:
				area.unhighlight()

func disable():
	_update_hightlight(true)
	monitoring = false

func enable():
	monitoring = true

func _get_closest_interactable():
	var closest_item = null
	var closest_item_dot_scale = -1
	if monitoring:
		for area in get_overlapping_areas():
			if closest_item == null:
				closest_item = area
			else:
				var item_dir = (area.global_position - global_position).normalized()
				var hand_dir = Vector2.RIGHT * scale.x
				var dot_scale = item_dir.dot(hand_dir)

				if dot_scale > closest_item_dot_scale:
					closest_item = area
					closest_item_dot_scale = dot_scale

	return closest_item

func hold_item(i):
	item = i
	hold.emit(i)
	interacting = false

func is_holding():
	return item != null
