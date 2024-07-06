extends Node2D

#@export var min_rotation := -20
#@export var max_rotation := 20
@export var max_offset := 500
@export var min_offset := 300
@export var duration := 1.0

@onready var target_pos: Vector2 = global_position
@onready var knockback_area = $KnockbackArea

var tw: Tween

func _ready():
	#var rot = randf_range(deg_to_rad(min_rotation), deg_to_rad(max_rotation))
	#global_rotation = rot
	
	var dir = Vector2.UP #.rotated(rot)
	global_position = target_pos - dir * randi_range(min_offset, max_offset)
	
	tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "global_position", target_pos, duration)
	await tw.finished
	
	knockback_area.enabled = false
