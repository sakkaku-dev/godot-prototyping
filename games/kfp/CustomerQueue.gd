class_name CustomerQueue
extends Queue

signal awaiting_order()

const GROUP = "CustomerQueue"

func _ready():
	add_to_group(GROUP)
	body_entered.connect(func(_c): awaiting_order.emit())
