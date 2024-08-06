class_name ShopResource
extends Resource

enum Item {
	EGG,
	CUTTING_BOARD,
	ORDER_DESK,
	LAYOUT,
}

@export var type := Item.EGG
@export var name := ""
@export var sprite: Texture2D
@export var price := 100
