class_name HitBox
extends Area2D

signal hit()

@export var damage := 1
@export var exclude: Area2D

func _ready():
	area_entered.connect(func(a):
		if exclude == a:
			return
		
		a.damage(damage)
		hit.emit()
	)

func set_exclude(x):
	exclude = x
