extends Area2D

signal player_detected(player)

@export var look_cast: RayCast2D
@export var nav: NavigationMove2D
@export var timer: RandomTimer

@export var max_wander_distance := 200
@export var min_wander_distance := 120

func _ready():
	exit()
	
	body_entered.connect(func(x):
		look_cast.target_position = x.global_position - look_cast.global_position
		
		if look_cast.is_colliding():
			print("Player detected")
			player_detected.emit(x)
	)
	
	timer.timeout.connect(func(): _set_random_target())
	nav.reached.connect(func(): timer.random_start())

func _set_random_target():
	var dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
	nav.set_target(global_position + dir * randf_range(min_wander_distance, max_wander_distance))

func process(delta):
	nav.process(delta)

func exit():
	timer.stop()

func enter():
	timer.random_start()
