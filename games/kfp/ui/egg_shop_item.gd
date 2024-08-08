extends RoomItemTile

@export var egg_placeholder: Sprite2D
@export var tile_map: TileMap
@export var egg_scene: PackedScene
@export var ground_layer := 1

var placing_eggs := false:
	set(v):
		placing_eggs = v
		egg_placeholder.visible = v
		#set_highlight(v)

func _ready() -> void:
	super._ready()
	self.placing_eggs = false
	
	KfpManager.eggs_changed.connect(func(): _update())
	buy.connect(func(res): KfpManager.buy_item(res))
	pressed.connect(func(): self.placing_eggs = not placing_eggs)

func get_count():
	return KfpManager.eggs
	
func use_item():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and placing_eggs:
		self.placing_eggs = false
		get_viewport().set_input_as_handled()
	
	if placing_eggs and event.is_action_pressed("action"):
		var ground_cells = tile_map.get_used_cells(ground_layer)
		var coord = _current_coord()
		
		if not coord in ground_cells:
			print("Not valid ground coord %s" % coord)
			return
		
		if not KfpManager.placed_egg():
			return
		
		var egg = egg_scene.instantiate()
		egg.global_position = _current_pos()
		egg.hatched.connect(func():
			KfpManager.add_random_chicken(egg.global_position)
			egg.queue_free()
		)
		tile_map.add_child(egg)
		
		if KfpManager.eggs <= 0:
			self.placing_eggs = false


func _process(delta):
	if not placing_eggs: return
	egg_placeholder.global_position = _current_pos()

func _current_pos():
	return tile_map.map_to_local(_current_coord())

func _current_coord():
	return tile_map.local_to_map(tile_map.get_global_mouse_position())
