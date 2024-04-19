class_name Chicken
extends CharacterBody2D

enum {
	MOVE,
	WORKING,
	RETURN,
}

signal died()
signal working_changed()

const DOOR_LAYER = 7

@export var max_active_orders := 5

@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer
@onready var navigation_move_2d = $NavigationMove2D
@onready var hand = $Hand
@onready var item_icon = $ItemIcon
@onready var worker_icon = $WorkerIcon

var state := MOVE
var work: WorkArea
var worker := false:
	set(v):
		worker = v
		worker_icon.visible = v

func _ready():
	self.worker = false
	idle_timer.timeout.connect(func():
		move_collide.stop()
		wander_timer.random_start()
	)
	wander_timer.timeout.connect(func():
		move_collide.random_direction()
		idle_timer.random_start()
	)

func start_work_day():
	state = WORKING
	_do_work()

func _physics_process(delta):
	if has_food():
		var takeout = get_takeout()
	
	match state:
		MOVE: move_collide.process(delta)
		WORKING: _do_work()
		
	navigation_move_2d.process(delta)
	
func _process(delta):
	item_icon.visible = hand.item != null

func _do_work():
	if get_order_count() < max_active_orders:
		var desk = get_order_desk()
		if desk:
			_go_to_work(desk)
			return
	
	if has_food():
		var takeout = get_takeout()
		if takeout:
			_go_to_work(takeout)
			return
	
	var board = get_cutting_board()
	if board:
		_go_to_work(board)
		return

func _go_to_work(work_area: WorkArea):
	work_area.lock_work()
	navigation_move_2d.set_target(work_area.global_position)
	await navigation_move_2d.reached
	hand.interact_start()
	await work_area.work_finished
	_do_work()

func get_order_count():
	return KFP.get_object(self).get_order_count()

func has_food():
	return hand.item != null

func get_takeout():
	for t in get_tree().get_nodes_in_group(TakeOut.TAKEOUT_GROUP):
		if t.has_available_work():
			return t
	return null

func get_order_desk():
	for t in get_tree().get_nodes_in_group(OrderDesk.ORDER_GROUP):
		if t.has_available_work():
			return t
	return null

func get_cutting_board():
	for t in get_tree().get_nodes_in_group(CuttingBoard.BOARD_GROUP):
		if t.has_available_work():
			return t
	return null
