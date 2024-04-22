class_name TakeOutQueue
extends Queue

signal awaiting_takeout()

const GROUP = "TakeOutQueue"

func _ready():
	add_to_group(GROUP)
	body_entered.connect(func(_c): awaiting_takeout.emit())
