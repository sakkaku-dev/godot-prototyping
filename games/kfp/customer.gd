class_name Customer
extends CharacterBody2D

const GROUP = "Customer"

signal order_failed()
signal order_completed(id)
signal leaving()
signal removed()

enum {
	MOVING_ORDER,
	ORDER,
	MOVING_TAKEOUT,
	WAITING,
	EATING,
	LEAVING,
	REMOVE,
}

@export var debug := false
@export var happy_face: Texture2D
@export var angry_face: Texture2D
@export var wait_emote: Texture2D

#@onready var move_target = $MoveTarget
@onready var people_detection = $PeopleDetection
@onready var order_wait_time = $OrderWaitTime
@onready var food_wait_time = $FoodWaitTime
@onready var navigation_move_2d = $NavigationMove2D
@onready var emote = $Emote

@onready var spawn_pos: Vector2 = global_position

var order_id := 0
var move_order: Node2D
var exit_order: Node2D
var current_queue: Queue

var target_desk: OrderDesk

var state = MOVING_ORDER:
	set(v):
		state = v
		
		if state == REMOVE:
			removed.emit()
			queue_free()
		elif state == ORDER:
			order_wait_time.start()
		elif state == LEAVING:
			leaving.emit()
			food_wait_time.stop()
			_move_to(spawn_pos, REMOVE)
			current_queue = null
		elif state == WAITING:
			food_wait_time.start()
		elif state == MOVING_TAKEOUT:
			order_wait_time.stop()
			
			var takeout = get_tree().get_first_node_in_group(TakeOutQueue.GROUP)
			if takeout == null:
				food_wait_time.start()
				state = WAITING
			else:
				current_queue = takeout
				var pos = current_queue.queue_customer(self)
				_move_to(pos, WAITING)
		elif state == MOVING_ORDER:
			current_queue = get_tree().get_first_node_in_group(CustomerQueue.GROUP)
			if current_queue:
				var pos = current_queue.queue_customer(self)
				_move_to(pos, ORDER)
			
			

func _ready():
	add_to_group(GROUP)
	
	emote.set_texture(null)
	order_wait_time.timeout.connect(func():
		emote.set_texture(angry_face)
		self.state = LEAVING
	)
	food_wait_time.timeout.connect(func(): leave_unhappy())
	
	_move_to_order_desk()

func leave_unhappy():
	emote.set_texture(angry_face)
	self.state = LEAVING
	order_failed.emit()

func _move_to_order_desk():
	self.state = MOVING_ORDER

func _move_to_takeout_order():
	self.state = MOVING_TAKEOUT

func _move_to(pos: Vector2, next_state):
	navigation_move_2d.set_target(pos)
	await navigation_move_2d.reached
	self.state = next_state

func _move_in_order(root: Node2D):
	for c in root.get_children():
		navigation_move_2d.set_target(c.global_position)
		await navigation_move_2d.reached

#func _unhandled_input(event):
	#if debug and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#var pos = get_global_mouse_position()
		#navigation_move_2d.set_target(pos)
		#print("Adding target: %s" % pos)

func _physics_process(delta):
	navigation_move_2d.process(delta)
	
	if state == MOVING_ORDER or state == MOVING_TAKEOUT:
		_detect_nearby_people()

func _detect_nearby_people():
	var dir = global_position.direction_to(navigation_move_2d.target_position)
	for area in people_detection.get_overlapping_areas():
		var curr_dir = global_position.direction_to(area.global_position)
		if current_queue and current_queue.is_in_queue(area.customer) and dir.dot(curr_dir) > 0.5:
			navigation_move_2d.stop = true
			return
	
	navigation_move_2d.stop = false

func is_ordering():
	return state == ORDER

func taken_order(id):
	emote.set_texture(wait_emote)
	order_id = id
	_move_to_takeout_order()

func finish_order():
	emote.set_texture(happy_face)
	self.state = LEAVING
	order_completed.emit(order_id)
