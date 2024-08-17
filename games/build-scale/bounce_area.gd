extends Area3D

@export var force := 20

func _ready() -> void:
	body_entered.connect(func(b: Coin):
		b.linear_velocity = Vector3.ZERO
		b.apply_central_impulse(Vector3.RIGHT.rotated(Vector3.FORWARD, -global_rotation.z) * force )# / (b.mass * b.mass))
		print("mass %s" % b.mass)
	)
