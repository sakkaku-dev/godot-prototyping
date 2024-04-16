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

@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer
@onready var navigation_move_2d = $NavigationMove2D
@onready var hand = $Hand
@onready var item = $Item

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
	set_collision_mask_value(6, false)

func stop_work():
	state = RETURN

func is_working():
	return state in [SEARCH_WORK, WORKING]

func _physics_process(delta):
	match state:
		MOVE: move_collide.process(delta)
		SEARCH_WORK: _search_work()
		WORKING: navigation_move_2d.process(delta)
	
func _process(delta):
	item.visible = hand.item != null

func _search_work():
	for w in get_tree().get_nodes_in_group(WorkArea.GROUP):
		if w.has_available_work():
			w.lock_work()
			work = w
			navigation_move_2d.set_target(work.global_position)
			state = WORKING
			return
