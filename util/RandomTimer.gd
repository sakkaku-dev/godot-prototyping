class_name RandomTimer
extends Timer

@export var min_time := 0.5
@export var max_time := 1.0

@onready var is_oneshot := one_shot
@onready var is_autostart := autostart

func _ready():
	one_shot = false
	autostart = false
	
	if not one_shot:
		timeout.connect(func(): random_start())
		
	if is_autostart:
		random_start()

func random_start():
	start(randf_range(min_time, max_time))
