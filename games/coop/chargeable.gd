class_name Chargeable
extends Node

signal charged()
signal charging_started()
signal charging_stopped()

@export var max_value := 1.0
@export var increase := 1.0
@export var activate_on_charged := false

var current_max_value := max_value
var value := 0.0:
	set(v):
		value = clamp(v, 0.0, max_value)
		
var is_charging := false:
	set(v):
		if v == is_charging: return
		
		is_charging = v
		if v:
			charging_started.emit()
		else:
			charging_stopped.emit()

func start(max_v = max_value):
	current_max_value = max_v
	value = 0.0
	is_charging = true

func stop():
	is_charging = false
	return value

func _process(delta):
	if not is_charging:
		return
	
	value += delta * increase
	if value >= current_max_value and activate_on_charged:
		is_charging = false
		charged.emit()
		value = 0.0
