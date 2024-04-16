class_name Interactable
extends Area2D

const INTERACTABLE_LAYER = 6

signal enable_highlight(enable)
signal interacted(actor)
signal interact_started(actor)

func _ready():
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(INTERACTABLE_LAYER, true)

func highlight():
	enable_highlight.emit(true)

func unhighlight():
	enable_highlight.emit(false)

func interact(actor):
	interacted.emit(actor)

func interact_start(actor):
	interact_started.emit(actor)
