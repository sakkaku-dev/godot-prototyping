class_name MeleeAttack
extends HitBox

signal finished()

@export var timer: Timer

var type: Parasite.Type

func _ready():
	area_entered.connect(func(a):
		if exclude == a:
			return
		a.damage(damage, type)
	)
	
	if timer:
		timer.timeout.connect(func():
			finished.emit()
			queue_free()
		)
