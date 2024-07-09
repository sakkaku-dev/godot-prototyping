class_name KnockbackArea
extends Area2D

signal hit()

@export var knockback := 200
@export var enabled := true
@export var continous := false

func _ready():
	body_entered.connect(func(a):
		if not enabled: return
		
		if a is Player:
			var dir = _get_push_dir(a)
			a.hit_knockback(dir * knockback)
			# TODO: break stone
			print("Hit player")
		
		hit.emit()
	)

func _get_push_dir(b: Node2D):
	var dir = global_position.direction_to(b.global_position)
	return Vector2(dir.x, 0)

func _process(delta):
	if continous:
		for b in get_overlapping_bodies():
			var dir = _get_push_dir(b)
			b.velocity = sign(dir.x) * knockback * delta
