extends Area3D

@export var force := 20
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	body_entered.connect(func(b: Coin):
		b.linear_velocity = Vector3.ZERO
		b.angular_velocity = Vector3.ZERO
		b.apply_central_impulse(Vector3.RIGHT.rotated(Vector3.FORWARD, -global_rotation.z) * force )
		animation_player.play("bounce")
	)
