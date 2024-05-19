class_name Hurtbox
extends Area2D

signal died()
signal health_changed(hp)

@export var health := 1

func damage(dmg: int):
	health -= dmg
	health_changed.emit(health)
	
	if health <= 0:
		died.emit()
