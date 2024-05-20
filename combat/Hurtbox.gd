class_name Hurtbox
extends Area2D

signal died()
signal health_changed(hp)

@export var max_health := 1
@onready var health := max_health

func damage(dmg: int):
	health -= dmg
	health_changed.emit(health)
	
	if health <= 0:
		died.emit()
