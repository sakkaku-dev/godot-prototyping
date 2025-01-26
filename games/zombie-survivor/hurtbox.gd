class_name Hurtbox3D
extends Area3D

signal died()
signal hit(knockback: Vector3)

@export var health := 10:
	set(v):
		health = v
		if health <= 0:
			died.emit()

func damage(dmg: int, pos: Vector3):
	health -= dmg
	hit.emit(pos.direction_to(global_position))
