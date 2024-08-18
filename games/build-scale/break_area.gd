extends Area3D

@export var force := 20
@export var break_mass := 2.0

func _ready() -> void:
	body_entered.connect(func(b: Coin):
		if b.mass > break_mass:
			b.break_sound.play()
			queue_free()
	)
