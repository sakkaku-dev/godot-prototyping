class_name Chicken
extends CharacterBody2D

enum {
	MOVE,
	SEARCH_WORK,
	WORKING,
	RETURN,
}

signal died()
signal working_changed()

@export var speed := 50

@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer

var state := MOVE
var work: WorkArea

func _ready():
	idle_timer.timeout.connect(func():
		move_collide.stop()
		wander_timer.random_start()
	)
	wander_timer.timeout.connect(func():
		move_collide.random_direction()
		idle_timer.random_start()
	)

func start_work():
	state = SEARCH_WORK

func stop_work():
	state = RETURN

func is_working():
	return state in [SEARCH_WORK, WORKING]

func _physics_process(delta):
	match state:
		MOVE: move_collide.process(delta)
		SEARCH_WORK: _search_work()
		WORKING: _go_work()

func _search_work():
	for w in get_tree().get_nodes_in_group(WorkArea.GROUP):
		if w.has_available_work():
			w.lock_work()
			work = w
			state = WORKING
			return

func _go_work():
	velocity = global_position.direction_to(work.global_position) * speed
	move_and_slide()
