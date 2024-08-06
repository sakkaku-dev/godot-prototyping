class_name ShopItem
extends TextureButton

signal buy(res: ShopResource)

@export var shop_item: ShopResource

@export var label: Label
@export var price_label: Label
@export var texture: TextureRect

func _ready() -> void:
	if shop_item:
		label.text = "%s" % shop_item.name
		texture.texture = shop_item.sprite
		price_label.text = "$%s -" % shop_item.price

	pressed.connect(func(): buy.emit(shop_item))
