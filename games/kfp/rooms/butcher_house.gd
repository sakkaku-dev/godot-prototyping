extends Node2D

@onready var droppable_area: DroppableArea = $DroppableArea
@onready var chicken_sprite: Sprite2D = $Chicken

@onready var tilemap: TileMapLayer= get_tree().get_first_node_in_group("map")
@onready var coord = tilemap.local_to_map(global_position)

var chicken: ChickenResource

func _ready() -> void:
	chicken_sprite.hide()
	droppable_area.dropped.connect(func(c):
		if c is Chicken and chicken == null:
			chicken = c.res
			chicken_sprite.visible = c != null
			KfpManager.use_chicken_for(c.res, coord)
			c.queue_free()
			_butcher_chicken()
	)
	
	KfpManager.chicken_added.connect(func(_x, _y): _butcher_chicken())
	_butcher_chicken()

func _butcher_chicken():
	if not KfpManager.is_farm_full():
		print("Farm is not full for butchering")
		return
		
	var available = KfpManager.get_available_chickens()
	if available.is_empty():
		print("No available chicken for butchering")
		return
	
	print("Butchering random chicken")
	KfpManager.butcher_chicken(available.pick_random())
