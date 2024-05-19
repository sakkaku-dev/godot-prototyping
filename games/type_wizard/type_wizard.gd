extends Node2D

@export var drop_chance := 0.1
@export var drop_scene: PackedScene

@export var wave_timer: WaveTimer
@export var enemies: Array[PackedScene] = []
@export var enemy_spawn_distance_from_player := 300

@export_category("UI Nodes")
@export var upgrades: Control
@export var blur: PauseBlur
@export var pickup_dialog: ItemPickUp

@onready var root = $Root
@onready var data_manager = $DataManager

var current_word
var shift_word

func _ready():
	wave_timer.start_wave()
	wave_timer.spawn.connect(_spawn)

func _spawn():
	var enemy = enemies.pick_random().instantiate()
	enemy.set_word(data_manager.get_random_enemy())
	enemy.global_position = (Vector2.RIGHT * enemy_spawn_distance_from_player).rotated(randf_range(0, TAU))
	enemy.finished.connect(func():
		current_word = null
		_maybe_drop_item(enemy.global_position)
	)
	root.add_child(enemy)

func _maybe_drop_item(pos: Vector2):
	if randf() < drop_chance:
		var node = drop_scene.instantiate()
		node.global_position = pos
		node.set_word("scrolls")
		root.add_child(node)

func _unhandled_input(event: InputEvent):
	if not event is InputEventKey or not event.pressed:
		return
	
	var key = _get_key_of_event(event)
	if not key: return
	
	if event.shift_pressed:
		if not shift_word:
			var drops = get_tree().get_nodes_in_group(TypedDrop.DROP_GROUP)
			shift_word = _find_first_words_with(key, drops)
			print("Searching for pickup item: %s" % shift_word)
			
		if shift_word:
			shift_word.handle_key(key)
	else:
		if not current_word:
			var enemies = get_tree().get_nodes_in_group(TypedEnemy.ENEMY_GROUP)
			current_word = _find_first_words_with(key, enemies)
			print("Searching for enemy: %s" % current_word)
		
		if current_word:
			current_word.handle_key(key)

func _get_key_of_event(ev: InputEventKey):
	var key = ev.duplicate() as InputEventKey
	
	# we don't care about modifiers
	key.shift_pressed = false
	key.ctrl_pressed = false
	key.alt_pressed = false
	key.meta_pressed = false
	
	var text = key.as_text()
	if text.length() != 1:
		return null
	return text

func _find_first_words_with(key: String, nodes: Array):
	var matches = []
	for node in nodes:
		if not node.is_on_screen(): continue
		
		if node.get_word().to_lower().begins_with(key.to_lower()):
			matches.append(node)
	
	var closest = null
	for m in matches:
		if closest == null or m.global_position.length() < closest.global_position.length():
			closest = m
	
	return closest

func _on_pickup_area_picked_up(type):
	if type == "scrolls":
		var scroll = data_manager.get_random_spell()
		if not scroll:
			print("Failed to find scroll name")
			return
		pickup_dialog.open(scroll, data_manager.get_spell(scroll))
