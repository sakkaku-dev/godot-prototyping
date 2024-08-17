class_name FireRateTimer
extends Timer

@export var hitbox: HitBox

func _ready() -> void:
	hitbox.monitoring = false
	one_shot = true

func fire():
	if not is_stopped(): return
	
	hitbox.monitoring = true
	start()
	
	get_tree().create_timer(0.2).timeout.connect(func(): hitbox.monitoring = false)
