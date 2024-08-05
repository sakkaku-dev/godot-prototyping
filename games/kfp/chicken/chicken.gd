class_name Chicken
extends CharacterBody2D

enum {
	MOVE,
	SEARCH_WORK,
	GO_WORK,
	WORKING,
}

signal clicked_chicken()
signal died()
signal working_changed()

const DOOR_LAYER = 7

@export var res: ChickenResource
@export var selectable: Selectable

@export_category("Old")
@export var max_active_orders := 5
@export var chicken_tex: Texture2D
@export var chicken_uniform: Texture2D

@onready var move_collide = $MoveCollide
@onready var idle_timer = $IdleTimer
@onready var wander_timer = $WanderTimer
@onready var navigation_move_2d = $NavigationMove2D
@onready var hand = $Hand
@onready var item_icon = $ItemIcon
@onready var worker_icon = $WorkerIcon
@onready var sprite_2d = $Sprite2D

#@onready var customer_manager := _customer_manager()

var state := MOVE:
	set(v):
		state = v
		
		#if not work: return
		#
		#if state == GO_WORK:
			#navigation_move_2d.set_target(work.global_position)
			#print("Go work")
		#elif state == WORKING:
			#_start_work()
		#elif state == SEARCH_WORK:
			#self.work = null

#var work: WorkArea:
	#set(v):
		#if work:
			#work.finished_work()
		#work = v
		#if work:
			#work.lock_work()
		
#var worker := false:
	#set(v):
		#worker = v
		#global_position = _get_new_spawn()
		#sprite_2d.texture = chicken_uniform if worker else chicken_tex
		#
		#if not worker:
			#self.work = null
			#navigation_move_2d.set_target(global_position)
		#elif customer_manager.is_open():
			#_start_work_day()

func _ready():
	worker_icon.hide()
	
	#self.worker = worker
	idle_timer.timeout.connect(func():
		move_collide.stop()
		wander_timer.random_start()
	)
	wander_timer.timeout.connect(func():
		move_collide.random_direction()
		idle_timer.random_start()
	)
	
	selectable.clicked.connect(func(): clicked_chicken.emit())
	
	#customer_manager.changed.connect(func(open):
		#if not worker or not open: return
		#_start_work_day()
	#)
	navigation_move_2d.reached.connect(func():
		#if worker:
			#self.state = WORKING
		#else:
		self.state = MOVE
	)

#func _start_work_day():
	#self.state = SEARCH_WORK
#
#func _get_new_spawn():
	#if worker:
		#return customer_manager.chicken_worker_spawn.global_position
	#return customer_manager.chicken_farm_spawn.global_position

#func _customer_manager() -> CustomerManager:
	#return get_tree().get_first_node_in_group(CustomerManager.GROUP)

func _physics_process(delta):
	#if state in [SEARCH_WORK, MOVE]:
	move_collide.process(delta)
	#else:
		#navigation_move_2d.process(delta)
	
	#if state == SEARCH_WORK:
		#_search_for_work()
	
func _process(delta):
	item_icon.visible = hand.item != null

#func _search_for_work():
	#if has_food():
		#var takeout = get_takeout()
		#if takeout:
			#_go_to_work(takeout)
			#print("Go to takeout")
			#return
	#
	#var orders = get_order_count()
	#if orders < max_active_orders:
		#var desk = get_order_desk()
		#if desk:
			#_go_to_work(desk)
			#print("Go to order desk")
			#return
	#
	#var board = get_cutting_board()
	#if board and orders > 0 and not has_food():
		#_go_to_work(board)
		#print("Go to cutting board")
		#return

#func _go_to_work(work_area: WorkArea):
	#self.work = work_area
	#self.state = GO_WORK
#
#func _start_work():
	#hand.interact_start()
	#print("Start work")
	#await work.work_finished
	#print("Finish work")
	#self.state = SEARCH_WORK
#
#func get_order_count():
	#return KFP.get_object(self).get_order_count()
#
#func has_food():
	#return hand.item != null
#
#func get_takeout():
	#for t in get_tree().get_nodes_in_group(TakeOut.TAKEOUT_GROUP):
		#if t.has_available_work():
			#return t
	#return null
#
#func get_order_desk():
	#for t in get_tree().get_nodes_in_group(OrderDesk.ORDER_GROUP):
		#if t.has_available_work():
			#return t
	#return null
#
#func get_cutting_board():
	#for t in get_tree().get_nodes_in_group(CuttingBoard.BOARD_GROUP):
		#if t.has_available_work():
			#return t
	#return null
