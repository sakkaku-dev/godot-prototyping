extends Node2D

@export var max_capacity := 1

@onready var droppable_area: DroppableArea = $DroppableArea
@onready var countdown: HatchCountdown = $Countdown
@onready var capacity_label: Label = $Capacity
@onready var chicken: Sprite2D = $Chicken
@onready var selectable: Selectable = $Selectable
@onready var click_timeout: Timer = $ClickTimeout

@onready var tilemap: TileMapLayer= get_tree().get_first_node_in_group("map")
@onready var coord = tilemap.local_to_map(global_position)

var chickens := []

func _ready() -> void:
	_update()
	droppable_area.dropped.connect(_on_dropped)
	
	KfpManager.chicken_removed.connect(func(_x): start_hatching())
	KfpManager.items_changed.connect(func(type): if type == KfpUpgradeManager.EGG: start_hatching())
	countdown.hatched.connect(func():
		KfpManager.hatch_egg(coord, global_position)
		start_hatching()
	)
	selectable.clicked.connect(func(): click_timeout.start())

func start_hatching():
	if KfpManager.is_farm_full() or not countdown.has_hatched or chickens.is_empty():
		print("Farm full: %s, Has Hatched: %s" % [KfpManager.is_farm_full(), countdown.has_hatched])
		return
	
	if KfpManager.get_item_count(KfpUpgradeManager.EGG) > 0:
		print("Starting hatching using nest")
		KfpManager.start_hatching(coord, countdown.hatch_value)
		_update()
		countdown.restart()
		KfpManager.use_item(KfpUpgradeManager.EGG)

func _on_dropped(node):
	if not node is Chicken:
		return
	
	if chickens.size() >= max_capacity:
		print("Nest is full")
		return
	
	chickens.append(node.res)
	KfpManager.use_chicken_for(node.res, coord)
	node.queue_free()
	_update()
	
	start_hatching()

func _update():
	countdown.multiplier = chickens.size() / 2.
	chicken.visible = chickens.size() > 0
	capacity_label.text = "%s / %s" % [chickens.size(), max_capacity]
