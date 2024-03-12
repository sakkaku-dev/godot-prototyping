class_name Hurtbox
extends Area2D

signal died()

@export var health := 1

func damage(dmg: int):
	health -= dmg
	
	if health <= 0:
		died.emit()
