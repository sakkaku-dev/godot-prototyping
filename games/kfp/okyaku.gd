class_name Customer
extends CharacterBody2D

signal order_failed()

enum {
	MOVING_ORDER,
	ORDER,
	WAITING,
	EATING,
	LEAVING,
}

@onready var move_target = $MoveTarget
@onready var people_detection = $PeopleDetection
@onready var order_wait_time = $OrderWaitTime
@onready var food_wait_time = $FoodWaitTime

@onready var exit_order := [global_position]

var order_id := 0
var move_order := []
var state = MOVING_ORDER:
	set(v):
		state = v
		
		if state == ORDER:
			order_wait_time.start()
		elif state == LEAVING:
			people_detection.monitorable = false
			await _move_in_order(exit_order)
		elif state == WAITING:
			order_wait_time.stop()
			food_wait_time.start()
			

func _ready():
	order_wait_time.timeout.connect(func():self.state = LEAVING)
	food_wait_time.timeout.connect(func():
		self.state = LEAVING
		order_failed.emit()
	)
	
	await get_tree().create_timer(1.0).timeout
	await _move_in_order(move_order)
	self.state = ORDER

func _move_in_order(pos):
	while pos.size() > 0:
		move_target.current_target = pos.pop_front()
		await move_target.reached

func _process(delta):
	match state:
		MOVING_ORDER:
			_detect_nearby_people()

func _detect_nearby_people():
	for area in people_detection.get_overlapping_areas():
		var dir = global_position.direction_to(area.global_position)
		if dir.dot(move_target.current_dir) > 0.75:
			move_target.stop = true
			return
	
	move_target.stop = false

func is_ordering():
	return state == ORDER

func taken_order(id):
	self.state = WAITING
	order_id = id
