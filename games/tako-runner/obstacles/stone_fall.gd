extends Node2D

@export var offset := 500
@export var duration := 1.0
@export var delay := 0.5

@onready var target_pos: Vector2 = global_position
@onready var knockback_area = $KnockbackArea
@onready var color_rect = $ColorRect
@onready var collision_shape_2d = $CollisionShape2D

var tw: Tween

func _ready():
	var dir = Vector2.DOWN
	global_position = target_pos - dir * offset
	collision_shape_2d.disabled = true
	await get_tree().create_timer(delay).timeout
	
	tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tw.tween_property(self, "global_position", target_pos, duration)
	#tw.tween_property(color_rect, "modulate", Color.TRANSPARENT, duration)
	await tw.finished
	
	
	collision_shape_2d.disabled = false
	knockback_area.enabled = false
