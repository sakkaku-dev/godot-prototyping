class_name CustomerQueue
extends Queue

const GROUP = "CustomerQueue"

func _ready():
	add_to_group(GROUP)
	super._ready()
