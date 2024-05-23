extends TimedZoneSpell

@export var force := 10

func _physics_process(delta):
	for body in get_overlapping_bodies():
		body.knockback = body.global_position.normalized() * force
