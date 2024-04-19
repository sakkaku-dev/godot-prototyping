class_name Customer
extends CharacterBody2D

signal order_failed()
signal order_completed()
signal leaving()

enum {
	MOVING_ORDER,
	ORDER,
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

var state = MOVING_ORDER:
	set(v):
		state = v
		
		if state == ORDER:
			order_wait_time.start()
		elif state == LEAVING:
			leaving.emit()
			food_wait_time.stop()
			people_detection.monitorable = false
			await _move_in_order(exit_order)
			

func _ready():
	emote.set_texture(null)
	order_wait_time.timeout.connect(func(): self.state = LEAVING)
	food_wait_time.timeout.connect(func():
		emote.set_texture(angry_face)
		self.state = LEAVING
		order_failed.emit()
	)
	
	_move_to_order_desk()

func _move_to_order_desk():
	var queue := get_tree().get_first_node_in_group(CustomerQueue.GROUP)
	var pos = queue.queue_customer(self)
	await _move_to(pos)
	self.state = ORDER

func _move_to_takeout_order():
	order_wait_time.stop()
	food_wait_time.start()
	var queue := get_tree().get_first_node_in_group(TakeOutQueue.GROUP)
	var pos = queue.queue_customer(self)
	await _move_to(pos)
	self.state = WAITING

func _move_to(pos: Vector2):
	navigation_move_2d.set_target(pos)
	await navigation_move_2d.reached

func _move_in_order(root: Node2D):
	for c in root.get_children():
		navigation_move_2d.set_target(c.global_position)
		await navigation_move_2d.reached

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var pos = get_global_mouse_position()
		navigation_move_2d.set_target(pos)
		print("Adding target: %s" % pos)

func _physics_process(delta):
	navigation_move_2d.process(delta)
	
	if state == MOVING_ORDER:
		_detect_nearby_people()

func _detect_nearby_people():
	for area in people_detection.get_overlapping_areas():
		var dir = global_position.direction_to(area.global_position)
		if velocity.length() < 0.01 or dir.dot(velocity) > 0.9:
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
