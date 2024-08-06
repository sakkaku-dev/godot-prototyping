extends ShopItem

@export var layout_scene: PackedScene

func _ready() -> void:
	super._ready()
	buy.connect(func(res):
		pass
	)
