extends CharacterBody2D

@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer

func _ready():
	idle_timer.timeout.connect(func():
		move_collide.stop()
		wander_timer.random_start()
	)
	wander_timer.timeout.connect(func():
		move_collide.random_direction()
		idle_timer.random_start()
	)
