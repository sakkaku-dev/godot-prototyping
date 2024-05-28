extends Node2D

@export var wave_timer: WaveTimer
@export var enemies: Array[PackedScene] = []

@export_category("UI Nodes")
@export var upgrades: Upgrades
@export var blur: PauseBlur
@export var pickup_dialog: ItemPickUp
@export var manage: Manage
@export var scrolls: ScrollsContainer

@onready var data_manager = $DataManager
@onready var key_reader = $KeyReader
@onready var enemy_spawner = $EnemySpawner
@onready var wizard = $Root/Wizard

var enemy_word: TypedCharacter
var pickup_word: TypedCharacter

func _ready():
	wave_timer.spawn.connect(func(): enemy_spawner.spawn())

	key_reader.pressed_key.connect(_pressed_key)
	key_reader.pressed_cancel.connect(_cancel_word)

	wizard.level_up.connect(func(): _wave_ended())
	upgrades.selected_upgrade.connect(_selected_upgrade)
	#manage.next_wave.connect(func(): wave_timer.start_wave())
	
	enemy_spawner.drop_finished.connect(func(): pickup_word = null)
	enemy_spawner.enemy_finished.connect(func(): enemy_word = null)
	enemy_spawner.enemy_removed.connect(func(e):
		#if wave_timer.is_stopped() and left.is_empty():
			#_wave_ended()
		
		wizard.killed_enemy(e)
	)
	
	wizard.cast_spell.connect(func(scroll):
		var spell = data_manager.get_spell(scroll)
		wizard.cast(spell.spell)
	)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		wave_timer.start_wave()

func _wave_ended():
	var ups = data_manager.get_random_upgrades()
	if not ups.is_empty():
		upgrades.show_upgrades(ups)

func _selected_upgrade(upgrade: UpgradeResource):
	wizard.upgrade(upgrade)
	data_manager.used_upgrade(upgrade)
	wave_timer.start_wave()

func _pressed_key(key: String, _shift: bool):
	if wizard.casting:
		scrolls.handle_key(key)
		return

	wizard.handle_key(key)

	#if wizard.pickup_enabled:
		#if not pickup_word:
			#var drops = get_tree().get_nodes_in_group(TypedDrop.DROP_GROUP)
			#pickup_word = _find_first_words_with(key, drops)
			#print("Searching for pickup item: %s" % pickup_word)
			#
		#_handle_key(key, pickup_word)
	#else:
		#if not enemy_word:
			#var enemies = enemy_spawner.get_available_enemies()
			#enemy_word = _find_first_words_with(key, enemies)
			#print("Searching for enemy: %s" % enemy_word)
		#
		#_handle_key(key, enemy_word)

#func _handle_key(key, word):
	#var correctly_handled = false
	#if word:
		#correctly_handled = word.handle_key(key)
	#
	#wizard.handled_key(correctly_handled)

func _cancel_word(_shift: bool):
	if wizard.casting:
		scrolls.cancel()
		return
		
	wizard.cancel()
	
	#if wizard.pickup_enabled:
		#if not pickup_word: return
		##pickup_word.cancel()
		##pickup_word = null
	#else:
		#if not enemy_word: return
		#enemy_word.cancel()
		#enemy_word = null

func _find_first_words_with(key: String, nodes: Array):
	var matches = []
	for node in nodes:
		if not node.is_on_screen(): continue
		
		if node.get_remaining_word().to_lower().begins_with(key.to_lower()):
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
		wizard.add_scroll(scroll)
