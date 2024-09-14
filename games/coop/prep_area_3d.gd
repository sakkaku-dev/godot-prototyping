class_name PrepArea3D
extends Interactable3D

@export var type := PotionItem.Process.CUTTING
@export var default_process_time := 1.0
@export var item_node: ItemNodes
@export var icon: ActionIcon

var item: PotionItem:
	set(v):
		item = v
		if item == null:
			icon.hide()
			item_node.hide_all()
		else:
			icon.visible = can_prepare(item)
			item_node.show_item(item)

var is_preparing := false

func _ready():
	reset()

func reset():
	item = null

func _process(delta: float) -> void:
	if item and is_preparing:
		item.processed += delta
		icon.set_fill(item.processed / default_process_time)
		
		if item.processed >= default_process_time:
			processed_item()

func processed_item():
	if item == null:
		print("No item to process")
		return
		
	if not item.type in PotionItem.PROCESSES[type]:
		print("Cannot process %s" % item.get_name())
		return

	stop_process()
	
	print("Item processed: %s" % item.get_name())
	var new_type = PotionItem.PROCESSES[type][item.type]
	item = PotionItem.new(new_type)

func can_prepare(item):
	return item is PotionItem and item.type in PotionItem.PROCESSES[type]

func interact(hand: Hand3D):
	if pickupable:
		hand.hold_item(GridItem.new(GridItem.Type.PREP_AREA, {"item": item}), global_position)
		queue_free()
		return
	
	if item == null:
		if not hand.is_holding_item():
			print("Not holding any items to put in")
			return
		if not hand.item is PotionItem:
			print("Only potion items can be placed at the PrepArea")
			return
		
		item = hand.take_item()
	else:
		if hand.is_holding_item():
			print("Already holding an item. Cannot prepare %s" % item.get_name())
			return
		
		hand.hold_item(item)
		item = null

func action(hand: Hand3D, pressed: bool):
	if pickupable:
		print("In pickup mode")
		return
	
	if pressed and not can_prepare(item):
		print("Cannot prepare %s at this station" % item.get_name())
		return
	
	if pressed:
		start_process()
	else:
		stop_process()

func start_process():
	if item == null:
		print("No item to process")
		return
	
	if item.process_type < 0:
		item.process_type = type
	elif item.process_type != type:
		print("item is already processed as %s" % PotionItem.Process.keys()[item.process_type])
		return
	
	print("Start processing %s: %s" % [item.get_name(), item.processed])
	is_preparing = true

func stop_process():
	if item == null:
		print("No item to stop processing")
		return
	
	if item.process_type == null:
		print("Item has not started processing")
		return
	
	print("Stop processing %s: %s" % [item.get_name(), item.processed])
	is_preparing = false
