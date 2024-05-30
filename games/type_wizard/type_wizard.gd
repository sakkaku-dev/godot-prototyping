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

func _ready():
	wave_timer.spawn.connect(func(): enemy_spawner.spawn())

	key_reader.pressed_key.connect(_pressed_key)
	key_reader.pressed_cancel.connect(_cancel_word)

	wizard.upgrade(load("res://games/type_wizard/upgrades/CastleArcherCountUpgrade.tres"))
	wizard.level_up.connect(func(): _wave_ended())
	upgrades.selected_upgrade.connect(_selected_upgrade)
	
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

func _cancel_word(_shift: bool):
	if wizard.casting:
		scrolls.cancel()
		return
		
	wizard.cancel()

func _on_pickup_area_picked_up(type):
	if type == "scrolls":
		var scroll = data_manager.get_random_spell()
		if not scroll:
			print("Failed to find scroll name")
			return
		
		pickup_dialog.open_for_spells(scroll, data_manager.get_spell(scroll))
		wizard.add_scroll(scroll)
