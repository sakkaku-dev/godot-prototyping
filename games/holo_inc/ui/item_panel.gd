class_name ItemPanel
extends Control

@export var item := HoloIncData.Item.GACHA
@export var count_label: Label
@export var price_button: BaseButton

func _ready() -> void:
	_update()
	HoloIncData.item_bought.connect(func(i: HoloIncData.Item): if i == item: _update())
	HoloIncData.holo_coins_changed.connect(func(): _update())
	
	if price_button:
		price_button.pressed.connect(func(): HoloIncData.buy(item))

func _update():
	_coins_changed()
	
	if count_label:
		count_label.text = "%.0f" % HoloIncData.get_count(item)
	if price_button and price_button is Button:
		price_button.text = "Buy %s (%s)" % [HoloIncData.Item.keys()[item], HoloIncData.get_price(item)]

func _coins_changed():
	visible = HoloIncData.can_buy(item) or HoloIncData.get_count(item) > 0
	if price_button:
		price_button.disabled = not HoloIncData.can_buy(item)
