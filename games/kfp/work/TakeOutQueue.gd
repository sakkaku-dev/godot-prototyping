class_name TakeOutQueue
extends Queue

const GROUP = "TakeOutQueue"

func _ready():
	super._ready()
	add_to_group(GROUP)
