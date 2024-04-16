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
		elif state == WAITING:
			order_wait_time.stop()
			food_wait_time.start()
			

func _ready():
	emote.texture = null
	order_wait_time.timeout.connect(func(): self.state = LEAVING)
	food_wait_time.timeout.connect(func():
		emote.texture = angry_face
		self.state = LEAVING
		order_failed.emit()
	)
	
	await get_tree().create_timer(1.0).timeout
	await _move_in_order(move_order)
	self.state = ORDER

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
	if state == MOVING_ORDER:
		navigation_move_2d.process(delta)
		_detect_nearby_people()
	if state == LEAVING:
		navigation_move_2d.process(delta)

func _detect_nearby_people():
	for area in people_detection.get_overlapping_areas():
		var dir = global_position.direction_to(area.global_position)
		if dir.dot(velocity) > 0.75:
			navigation_move_2d.stop = true
			return
	
	navigation_move_2d.stop = false

func is_ordering():
	return state == ORDER

func taken_order(id):
	emote.texture = wait_emote
	self.state = WAITING
	order_id = id

func finish_order():
	emote.texture = happy_face
	self.state = LEAVING
	order_completed.emit()
