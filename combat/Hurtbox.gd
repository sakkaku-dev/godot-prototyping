class_name Hurtbox
extends Area2D

signal died()
signal health_changed(hp)
signal max_health_changed(max)

@export var max_health := 1:
	set(v):
		max_health = v
		max_health_changed.emit(max_health)
		
@onready var health := max_health:
	set(v):
		health = v
		health_changed.emit(health)
	
		if health <= 0:
			died.emit()

func damage(dmg: int):
	self.health -= dmg

func add_max_health(v):
	max_health += v
	health += v
