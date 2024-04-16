extends CharacterBody2D

@onready var hand = $Hand
@onready var top_down_move_2d = $TopDownMove2D
@onready var item = $Item

func _physics_process(delta):
	if hand.interacting: return
	top_down_move_2d.process(delta)

func _process(delta):
	item.visible = hand.item != null

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		hand.interact_start()
		get_viewport().set_input_as_handled()
	if event.is_action_released("interact"):
		hand.interact()
		get_viewport().set_input_as_handled()
