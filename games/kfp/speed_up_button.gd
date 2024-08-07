extends BaseButton

@export var speed_up_time := 10.0

func _ready():
	toggled.connect(func(on): Engine.time_scale = speed_up_time if on else 1.0)
