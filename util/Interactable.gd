class_name Interactable
extends Area2D

const INTERACTABLE_LAYER = 6

signal enable_highlight(enable)
signal interacted(actor)
signal interact_started(actor)

@export var enabled := true

var is_highlighted := false

func _ready():
	collision_layer = 0
	collision_mask = 0
	
	set_collision_layer_value(INTERACTABLE_LAYER, true)

func highlight():
	is_highlighted = true
	enable_highlight.emit(true)

func unhighlight():
	is_highlighted = false
	enable_highlight.emit(false)

func interact(actor):
	if enabled:
		interacted.emit(actor)

func interact_start(actor):
	if enabled:
		interact_started.emit(actor)
