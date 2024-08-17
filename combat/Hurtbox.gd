class_name Hurtbox
extends Area2D

signal hit()
signal hit_by(target)
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

func damage(dmg: int, target: Node2D):
	self.health -= dmg
	hit.emit()
	hit_by.emit(target)

func add_max_health(v):
	max_health += v
	health += v

func update_max_health(v):
	self.max_health = v
	self.health = v
