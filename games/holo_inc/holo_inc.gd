extends Node2D

@export_category("Characters")
@export var gacha_button: Button
@export var character_label: Label
@export var character_list: Control

@export_category("Coins")
@export var holo_container: Control
@export var holo_button: BaseButton
@export var holo_label: Label
@onready var holo_coins := 0.0:
	set(v):
		holo_coins = v
		holo_label.text = "%.0f" % v
		_update_gacha()

var gacha_bought := 0
var gacha_price_fn = func(x): return floor(log(x) * 100 + 10)

func _ready() -> void:
	holo_button.button_up.connect(func(): self.holo_coins += 1)
	
	_increase_gacha()
	gacha_button.pressed.connect(func(): _add_random_character())

func _process(delta: float) -> void:
	self.holo_coins += delta * HoloIncData.count_characters_doing(HoloIncData.Action.COLLECTING_COINS)

func _increase_gacha():
	gacha_bought += 1
	_update_gacha()

func _update_gacha():
	var price = gacha_price_fn.call(gacha_bought)
	gacha_button.text = "Buy (%s)" % price
	gacha_button.disabled = price > holo_coins

func _add_random_character():
	self.holo_coins -= gacha_price_fn.call(gacha_bought)
	HoloIncData.add_random_character()
	character_label.text = "%s" % HoloIncData.get_total_characters()
	_increase_gacha()
