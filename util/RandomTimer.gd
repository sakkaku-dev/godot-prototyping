class_name RandomTimer
extends Timer

@export var min_time := 0.5
@export var max_time := 1.0
@export var debug := false

@export var enter_notifier: VisibleOnScreenNotifier2D

@onready var is_oneshot := one_shot
@onready var is_autostart := autostart

func _ready():
	one_shot = true
	autostart = false
	
	if enter_notifier:
		enter_notifier.screen_entered.connect(func():
			if debug: print("Enter")
			start(0.0)
		)
		enter_notifier.screen_exited.connect(func():
			if debug: print("Exited")
			stop()
		)
	
	if not is_oneshot:
		timeout.connect(func(): random_start())
		
	if is_autostart and (enter_notifier == null or enter_notifier.is_on_screen()):
		random_start()

func random_start():
	var time = randf_range(min_time, max_time)
	start(time)
