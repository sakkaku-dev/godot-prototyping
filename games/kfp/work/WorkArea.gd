class_name WorkArea
extends Node2D

const GROUP = "WorkArea"

signal work_finished()
signal clicked()

@export var interact: Interactable
@export var chicken_sprite: Sprite2D
@export var mouse_control: Control

#@onready var cursor := KiaraKFP.get_object(self).cursor

var current_hand: Hand
var is_moving := false:
	set(v):
		is_moving = v
		#cursor.is_focused = v
		visible = not is_moving
		
		if current_hand:
			current_hand.hold_item("" if is_moving else null)

var worker: ChickenResource:
	set(v):
		worker = v
		chicken_sprite.visible = v != null

#var is_occupied := false
#
#func _ready():
	#self.worker = null
	#add_to_group(GROUP)
	#
	#tree_exiting.connect(func():
		#if worker:
			#KfpManager.remove_assigned_chicken(worker)
	#)
	#
	#interact.interact_started.connect(func(a):
		##if handle_movement(a): return
		#do_action(a)
	#)
	#
	#mouse_control.mouse_entered.connect(func():
		#if KfpManager.assigning_chicken:
			#interact.highlight()
	#)
	#mouse_control.mouse_exited.connect(func(): interact.unhighlight())
	#mouse_control.gui_input.connect(func(ev: InputEvent):
		#if ev.is_action_pressed("action") and KfpManager.assigning_chicken:
			#self.worker = KfpManager.assigning_chicken
			#KfpManager.add_assigned_chicken()
	#)
#
#func _process(delta: float) -> void:
	#mouse_control.mouse_filter = Control.MOUSE_FILTER_STOP if KfpManager.assigning_chicken else Control.MOUSE_FILTER_IGNORE
#
#func do_action(_h: Hand):
	#pass
#
#func is_occupied():
	#return worker != null

#func has_available_work():
	#return not is_occupied or worker == null

#func lock_work():
	#is_occupied = true
	#print("Lock")
#
#func finished_work():
	#is_occupied = false
	#print("Unlock")

#func _unhandled_input(event):
	#if is_moving and event.is_action_pressed("action"):
		##global_position = cursor.global_position
		#self.is_moving = false
		#get_viewport().set_input_as_handled()
	#
	#if not _can_edit(): return
	#
	#if event.is_action_pressed("rotate"):
		#rotation += PI/2
		#get_viewport().set_input_as_handled()
	
#func _can_edit():
	#return not KFP.get_object(self).is_open() and interact.is_highlighted

#func handle_movement(hand: Hand):
	#if _can_edit() and not is_moving:
		#current_hand = hand
		#self.is_moving = true
		#return true
	#
	#return false
