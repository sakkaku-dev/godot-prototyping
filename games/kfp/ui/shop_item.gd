class_name ShopItem
extends TextureButton

signal buy(res: ShopResource)

@export var shop_item: ShopResource

@export var label: Label
@export var count_label: Label
@export var texture: TextureRect
@export var buy_button: BaseButton
@export var highlight_bg: ColorRect

func _ready() -> void:
	label.text = "%s" % shop_item.name
	texture.texture = shop_item.sprite
	buy_button.text = "Buy ($%s)" % shop_item.price
	count_label.hide()

	buy_button.pressed.connect(func(): buy.emit(shop_item))

func set_highlight(enabled: bool):
	highlight_bg.visible = enabled
