extends Node2D

@export var map: Control
@export var fight_button: BaseButton
@onready var fight_timer: Timer = $FightTimer

var tw: Tween

func _ready() -> void:
	map.hide()
	
	HoloIncData.item_bought.connect(func(item):
		if item == HoloIncData.Item.MAP:
			_show_map()
	)

	fight_timer.timeout.connect(func(): _simulate_fight())
	fight_button.pressed.connect(func():
		HoloIncData.start_fight()
	)
	HoloIncData.fighting_changed.connect(func():
		if HoloIncData.is_fighting:
			fight_timer.start()
		else:
			fight_timer.stop()
	)

func _show_map():
	map.show()

func _process(delta: float) -> void:
	HoloIncData.holo_coins += 1 + delta * 1000 * HoloIncData.count_characters_doing(HoloIncData.Action.COLLECTING_COINS, true)

func _simulate_fight():
	var team_strength = HoloIncData.get_team_strength()
	HoloIncData.enemy_health -= team_strength * randf_range(0.8, 1.2)

	var enemy_strength = HoloIncData.get_enemy_strength(HoloIncData.map)
	HoloIncData.team_health -= enemy_strength * randf_range(0.8, 1.2)
