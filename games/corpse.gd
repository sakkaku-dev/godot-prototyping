extends Interactable

@export var type := Enemy.Type.BAT

func _ready():
	interacted.connect(func(): queue_free())
