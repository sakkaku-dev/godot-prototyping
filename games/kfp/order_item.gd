extends SmoothPosition

signal removed()

@export var label: Label
@export var timer_rect: CircleTimer

var customer: Customer

func _ready():
	label.text = "%04d" % customer.order_id
	timer_rect.timer = customer.food_wait_time
	
	customer.order_failed.connect(func():
		_move_out()
	)
	customer.order_completed.connect(func():
		_move_out()
	)

func _move_out():
	set_new_position(position + Vector2.UP * 50)
	await tw.finished
	removed.emit()
	queue_free()
