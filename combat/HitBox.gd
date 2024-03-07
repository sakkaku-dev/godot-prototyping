class_name HitBox
extends Area2D

@export var damage := 1

func _ready():
	area_entered.connect(func(a): a.damage(damage))
