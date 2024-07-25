extends MarginContainer

@export var money: Label
@export var fish_count: Label

@export var shop_btn: BaseButton
@export var aquarium_btn: BaseButton

func _ready():
	aquarium_btn.pressed.connect(func(): DeepwaterGame.go_to_aquarium())
	
	DeepwaterGame.money_changed.connect(func(): _update_money())
	DeepwaterGame.aquarium_changed.connect(func(): _update_fish_count())

	_update_money()
	_update_fish_count()

func _update_money():
	money.text = "%s" % DeepwaterGame.money

func _update_fish_count():
	fish_count.text = "%s / %s" % [DeepwaterGame.aquarium.size(), DeepwaterGame.max_aquarium_capacity]
