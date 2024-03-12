class_name HitBox
extends Area2D

@export var damage := 1
@export var exclude: Area2D

func _ready():
	area_entered.connect(func(a):
		if exclude == a:
			return
		
		a.damage(damage)
	)

func set_exclude(x):
	exclude = x
