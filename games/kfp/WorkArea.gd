class_name WorkArea
extends Node2D

const GROUP = "WorkArea"

signal work_finished()

@export var interact: Interactable

@onready var cursor := KiaraKFP.get_object(self).cursor

var current_hand: Hand
var is_moving := false:
	set(v):
		is_moving = v
		cursor.is_focused = v
		visible = not is_moving
		
		if current_hand:
			current_hand.hold_item("" if is_moving else null)

var is_occupied := false

func _ready():
	add_to_group(GROUP)
	
	interact.interact_started.connect(func(a):
		if handle_movement(a): return
		do_action(a)
	)

func do_action(_h: Hand):
	pass

func has_available_work():
	return not is_occupied

func lock_work():
	is_occupied = true
	print("Lock")

func finished_work():
	is_occupied = false
	print("Unlock")

func _unhandled_input(event):
	if is_moving and event.is_action_pressed("action"):
		global_position = cursor.global_position
		self.is_moving = false
		get_viewport().set_input_as_handled()
	
	if not _can_edit(): return
	
	if event.is_action_pressed("rotate"):
		rotation += PI/2
		get_viewport().set_input_as_handled()
	
func _can_edit():
	return not KFP.get_object(self).is_open() and interact.is_highlighted

func handle_movement(hand: Hand):
	if _can_edit() and not is_moving:
		current_hand = hand
		self.is_moving = true
		return true
	
	return false
