extends Node2D

@export var map: Control
@export var fight_button: BaseButton

var tw: Tween

func _ready() -> void:
	map.hide()
	
	HoloIncData.item_bought.connect(func(item):
		if item == HoloIncData.Item.MAP:
			_show_map()
	)

	fight_button.pressed.connect(func(): HoloIncData.start_fight())

func _show_map():
	if map.visible:
		return

	map.show()

func _process(delta: float) -> void:
	HoloIncData.holo_coins += delta * 100 * HoloIncData.count_characters_doing(HoloIncData.Action.COLLECTING_COINS, true)

	if HoloIncData.is_fighting:
		var team_strength = HoloIncData.count_characters_doing(HoloIncData.Action.FIGHT_TEAM, true)
		HoloIncData.enemy_health -= delta * team_strength

		var enemy_strength = HoloIncData.get_enemy_strength(HoloIncData.map)
		HoloIncData.team_health -= delta * enemy_strength
