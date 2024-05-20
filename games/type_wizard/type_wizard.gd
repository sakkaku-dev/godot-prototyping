extends Node2D

@export var wave_timer: WaveTimer
@export var enemies: Array[PackedScene] = []

@export_category("UI Nodes")
@export var upgrades: Upgrades
@export var blur: PauseBlur
@export var pickup_dialog: ItemPickUp

@onready var data_manager = $DataManager
@onready var key_reader = $KeyReader
@onready var enemy_spawner = $EnemySpawner

var current_word: TypedCharacter
var shift_word: TypedCharacter

func _ready():
	wave_timer.start_wave()
	wave_timer.spawn.connect(func(): enemy_spawner.spawn())
	key_reader.pressed_key.connect(_pressed_key)
	upgrades.selected_upgrade.connect(_selected_upgrade)
	
	enemy_spawner.enemy_finished.connect(func(): current_word = null)
	enemy_spawner.enemy_removed.connect(func(left):
		if wave_timer.is_stopped() and left.is_empty():
			_wave_ended()
	)

func _wave_ended():
	upgrades.show_upgrades(data_manager.get_random_upgrades())

func _selected_upgrade(upgrade: UpgradeResource):
	wave_timer.start_wave()

func _pressed_key(key: String, shift: bool):
	if shift:
		if not shift_word:
			var drops = get_tree().get_nodes_in_group(TypedDrop.DROP_GROUP)
			shift_word = _find_first_words_with(key, drops)
			print("Searching for pickup item: %s" % shift_word)
			
		if shift_word:
			shift_word.handle_key(key)
	else:
		if not current_word:
			var enemies = enemy_spawner.get_available_enemies()
			current_word = _find_first_words_with(key, enemies)
			print("Searching for enemy: %s" % current_word)
		
		if current_word:
			current_word.handle_key(key)

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
		
		pickup_dialog.open_for_spells(scroll, data_manager.get_spell(scroll))