extends TextureButton

@export var label: Label
@export var egg_placeholder: Sprite2D
@export var tile_map: TileMap
@export var egg_scene: PackedScene

var placing_eggs := false:
	set(v):
		placing_eggs = v
		egg_placeholder.visible = v

func _ready():
	KfpManager.eggs_changed.connect(func(): _update())
	_update()
	
	self.placing_eggs = false
	pressed.connect(func(): self.placing_eggs = true)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		self.placing_eggs = false
	
	if placing_eggs and event.is_action_pressed("action"):
		if KfpManager.placed_egg():
			var egg = egg_scene.instantiate()
			egg.global_position = _current_pos()
			egg.hatched.connect(func():
				KfpManager.add_random_chicken(egg.global_position)
				egg.queue_free()
			)
			tile_map.add_child(egg)
			
			if KfpManager.eggs <= 0:
				self.placing_eggs = false
		else:
			print("NO EGGS")

func _update():
	label.text = "%s" % KfpManager.eggs

func _process(delta):
	if not placing_eggs: return
	
	egg_placeholder.global_position = _current_pos()

func _current_pos():
	var coord = tile_map.local_to_map(tile_map.get_global_mouse_position())
	return tile_map.map_to_local(coord)
