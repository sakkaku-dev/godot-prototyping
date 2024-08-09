extends Button

@export var sell_price := 10
@export var parent: TilePlacement 

func _ready() -> void:
	hide()
	parent.changed_placing.connect(func(on): visible = on)
	pressed.connect(func(): KfpManager.sell_supply(sell_price))
	text = "Sell($%s)" % sell_price
