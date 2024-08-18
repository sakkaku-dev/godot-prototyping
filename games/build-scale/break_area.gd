extends Area3D

@export var force := 20

var hit := false

func _ready() -> void:
	body_entered.connect(func(b: Coin):
		if b.mass > 1.5 and not hit:
			queue_free()
			hit = true
	)
