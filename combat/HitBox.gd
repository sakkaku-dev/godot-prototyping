class_name HitBox
extends Area2D

signal hit()
signal hit_target(target)

@export var damage := 1
@export var exclude: Area2D

func _ready():
	area_entered.connect(func(a):
		if exclude == a:
			return
		
		a.damage(damage, self)
		hit.emit()
		hit_target.emit(a)
	)

func set_exclude(x):
	exclude = x
