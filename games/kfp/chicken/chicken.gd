class_name Chicken
extends CharacterBody2D

signal clicked_chicken()

@export var res: ChickenResource
@export var selectable: Selectable

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
	
	selectable.clicked.connect(func(): clicked_chicken.emit())
	
	KfpManager.chicken_removed.connect(func(chicken):
		if chicken == res:
			queue_free()
	)

func _physics_process(delta):
	move_collide.process(delta)
