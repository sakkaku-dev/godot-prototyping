class_name Customer
extends CharacterBody2D

signal order_failed()
signal order_completed()
signal leaving()

enum {
	MOVING_ORDER,
	ORDER,
	MOVING_TAKEOUT,
	WAITING,
	EATING,
	LEAVING,
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

var order_id := 0
var move_order: Node2D
var exit_order: Node2D
var current_queue: Queue

var state = MOVING_ORDER:
	set(v):
		state = v
		
		if state == ORDER:
			order_wait_time.start()
		elif state == LEAVING:
			leaving.emit()
			food_wait_time.stop()
			people_detection.monitorable = false
			_move_in_order(exit_order)
			current_queue = null
		elif state == MOVING_TAKEOUT:
			order_wait_time.stop()
			food_wait_time.start()
			
			current_queue = get_tree().get_first_node_in_group(TakeOutQueue.GROUP)
			var pos = current_queue.queue_customer(self)
			_move_to(pos, WAITING)
		elif state == MOVING_ORDER:
			current_queue = get_tree().get_first_node_in_group(CustomerQueue.GROUP)
			var pos = current_queue.queue_customer(self)
			_move_to(pos, ORDER)
			
			

func _ready():
	emote.set_texture(null)
	order_wait_time.timeout.connect(func():
		emote.set_texture(angry_face)
		self.state = LEAVING
	)
	food_wait_time.timeout.connect(func():
		emote.set_texture(angry_face)
		self.state = LEAVING
		order_failed.emit()
	)
	
	_move_to_order_desk()

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

func _unhandled_input(event):
	if debug and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		navigation_move_2d.set_target(pos)
		print("Adding target: %s" % pos)

func _physics_process(delta):
	navigation_move_2d.process(delta)
	
	if state == MOVING_ORDER or state == MOVING_TAKEOUT:
		_detect_nearby_people()

func _detect_nearby_people():
	for area in people_detection.get_overlapping_areas():
		if current_queue and current_queue.is_in_queue(area.customer):
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
	order_completed.emit()
